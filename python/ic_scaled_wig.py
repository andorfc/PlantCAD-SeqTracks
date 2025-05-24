#!/usr/bin/env python3
import pandas as pd
import argparse

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', required=True, help='TSV file from probs_to_ic.py')
    parser.add_argument('--prefix', required=True, help='Output prefix for wig files')
    return parser.parse_args()

def main():
    args = parse_args()
    df = pd.read_csv(args.input, sep='\t')

    nts = ['A', 'C', 'G', 'T']
    # Write four wig files: one for each nucleotide scaled by information_content.
    for nt in nts:
        with open(f"{args.prefix}_{nt}_scaled.wig", 'w') as fout:
            for chrom, grp in df.groupby('chr'):
                fout.write(f"variableStep chrom={chrom} span=1\n")
                for _, row in grp.iterrows():
                    height = row['information_content'] * row[nt]
                    fout.write(f"{row['start']} {height:.4f}\n")

    # Write an additional wig file containing the information content at each position.
    with open(f"{args.prefix}_information.wig", 'w') as finfo:
        for chrom, grp in df.groupby('chr'):
            finfo.write(f"variableStep chrom={chrom} span=1\n")
            for _, row in grp.iterrows():
                finfo.write(f"{row['start']} {row['information_content']:.4f}\n")

    # Write another wig file with the scaled probability for the reference value.
    # This is computed as information_content * reference_score.
    with open(f"{args.prefix}_reference.wig", 'w') as fref:
        for chrom, grp in df.groupby('chr'):
            fref.write(f"variableStep chrom={chrom} span=1\n")
            for _, row in grp.iterrows():
                scaled_ref = row['information_content'] * row['reference_score']
                fref.write(f"{row['start']} {scaled_ref:.4f}\n")

    with open(f"{args.prefix}_nonreference.wig", 'w') as fref:
        for chrom, grp in df.groupby('chr'):
            fref.write(f"variableStep chrom={chrom} span=1\n")
            for _, row in grp.iterrows():
                scaled_ref = row['information_content'] * (1 - row['reference_score'])
                fref.write(f"{row['start']} {scaled_ref:.4f}\n")

if __name__ == "__main__":
    main()
