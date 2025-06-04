#!/usr/bin/env python3
import pandas as pd
import numpy as np
import argparse

def parse_args():
    parser = argparse.ArgumentParser(description='Convert nucleotide probabilities to Information Content.')
    parser.add_argument('-input', required=True, help='Input TSV file with nucleotide probabilities')
    parser.add_argument('-output', required=True, help='Output TSV with Information Content')
    return parser.parse_args()

def compute_ic(row):
    try:
        probs = np.array([
            float(row['A_score']),
            float(row['C_score']),
            float(row['G_score']),
            float(row['T_score'])
        ])
        with np.errstate(divide='ignore', invalid='ignore'):
            ic = 2 + np.nansum(probs * np.log2(probs + 1e-9))  # add small epsilon to avoid log(0)
        return round(ic, 2)
    except ValueError:
        return np.nan  # Return NaN for rows with invalid data

def main():
    args = parse_args()

    df = pd.read_csv(args.input, sep='\t')

    # Compute IC, skipping invalid entries
    df['information_content'] = df.apply(compute_ic, axis=1)

    # Count skipped rows
    skipped = df['information_content'].isna().sum()

    # Drop rows where IC couldn't be computed
    df = df.dropna(subset=['information_content'])

    output_df = df[['chr', 'start', 'information_content', 'reference_score','A_score', 'C_score', 'G_score', 'T_score']]
    output_df.columns = ['chr', 'start', 'information_content', 'reference_score', 'A', 'C', 'G', 'T']
    output_df.to_csv(args.output, sep='\t', index=False)

    print(f"Information content calculated and saved to {args.output}")
    print(f"Skipped {skipped} rows due to invalid nucleotide probabilities.")

if __name__ == "__main__":
    main()
