#!/usr/bin/env python3
import pandas as pd
import torch
from transformers import AutoModelForMaskedLM, AutoTokenizer
from torch.utils.data import Dataset, DataLoader
import numpy as np
import argparse
from tqdm import tqdm
import logging
import sys

def parse_args():
    parser = argparse.ArgumentParser(description="Predict nucleotide probabilities with PlantCaduceus")
    parser.add_argument("-input", required=True, help="Input TSV with columns: gene_model, chr, pos, reference, sequence")
    parser.add_argument("-output", required=True, help="Output TSV with probabilities")
    parser.add_argument("-model", required=True, help="Path to pre-trained model")
    parser.add_argument("-device", default="cuda", help="Computation device (cuda or cpu)")
    parser.add_argument("-batch_size", type=int, default=128, help="Batch size for predictions")
    parser.add_argument("-mask_idx", type=int, default=255, help="Index to mask (0-based, default 255 for center)")
    return parser.parse_args()

class SequenceDataset(Dataset):
    def __init__(self, sequences, tokenizer, mask_idx):
        self.sequences = sequences
        self.tokenizer = tokenizer
        self.mask_idx = mask_idx

    def __len__(self):
        return len(self.sequences)

    def __getitem__(self, idx):
        seq = self.sequences[idx]
        encoding = self.tokenizer(seq, return_tensors="pt")
        input_ids = encoding["input_ids"].squeeze()
        input_ids[self.mask_idx] = self.tokenizer.mask_token_id
        return input_ids

def get_dataloader(sequences, tokenizer, batch_size, mask_idx):
    dataset = SequenceDataset(sequences, tokenizer, mask_idx)
    return DataLoader(dataset, batch_size=batch_size, shuffle=False)

def load_model(model_name, device):
    logging.info(f"Loading model: {model_name}")
    model = AutoModelForMaskedLM.from_pretrained(model_name, trust_remote_code=True)
    tokenizer = AutoTokenizer.from_pretrained(model_name, trust_remote_code=True)
    model.to(device).eval()
    return model, tokenizer

def main():
    logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(message)s')
    args = parse_args()

    # Check for CUDA availability if requested:
    if args.device.lower() == "cuda" and not torch.cuda.is_available():
        logging.warning("CUDA was requested but is not available! Switching to CPU.")
        args.device = "cpu"
    else:
        logging.info(f"Using device: {args.device}")

    # Read the input TSV without header and assign column names.
    col_names = ["gm", "chr", "start", "reference", "sequence"]
    df = pd.read_csv(args.input, sep='\t', header=None, names=col_names)

    sequences = df['sequence'].tolist()
    # The 'reference' column holds the nucleotide of interest.
    references = df['reference'].tolist()

    model, tokenizer = load_model(args.model, args.device)
    dataloader = get_dataloader(sequences, tokenizer, args.batch_size, args.mask_idx)

    ref_idx_map = {'A': 0, 'C': 1, 'G': 2, 'T': 3}

    # Open the output file for streaming writes.
    with open(args.output, 'w') as fout:
        # Write header (optional – remove if you don't want a header)
        header = "\t".join(["gm", "chr", "start", "reference", "sequence", "reference_score", "A_score", "C_score", "G_score", "T_score"])
        fout.write(header + "\n")
        fout.flush()  # flush right after writing header

        # We'll use an index pointer to map predictions back to the original rows.
        index = 0

        for batch in tqdm(dataloader, desc="Predicting"):
            batch = batch.to(args.device)
            with torch.no_grad():
                logits = model(batch).logits[:, args.mask_idx, :]
                nt_indices = [tokenizer.get_vocab()[nt.lower()] for nt in ['A', 'C', 'G', 'T']]
                logits_nt = logits[:, nt_indices]
                batch_probs = torch.softmax(logits_nt, dim=1).cpu().numpy()

            # Loop over predictions in the current batch.
            for prob in batch_probs:
                df_row = df.iloc[index]
                ref_letter = df_row['reference']
                # Compute the score corresponding to the reference nucleotide.
                ref_score = prob[ref_idx_map[ref_letter]]
                # Create an output line with the original data plus the prediction scores.
                out_fields = [
                    str(df_row["gm"]),
                    str(df_row["chr"]),
                    str(df_row["start"]),
                    df_row["reference"],
                    df_row["sequence"],
                    f"{ref_score:.4f}",
                    f"{prob[0]:.4f}",
                    f"{prob[1]:.4f}",
                    f"{prob[2]:.4f}",
                    f"{prob[3]:.4f}"
                ]
                out_line = "\t".join(out_fields)
                fout.write(out_line + "\n")
                fout.flush()  # flush after writing every line
                #print(out_line, flush=True)  # print to stdout and flush
                index += 1

    logging.info(f"Results saved to {args.output}")

if __name__ == "__main__":
    main()
