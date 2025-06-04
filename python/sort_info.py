#!/usr/bin/env python3
import argparse
import pandas as pd

def load_and_sort_tsv(infile: str) -> pd.DataFrame:
    # Read the TSV into a DataFrame
    df = pd.read_csv(infile, sep='\t')
    # Sort by chromosome then start position
    df_sorted = df.sort_values(by=['chr', 'start'])
    return df_sorted

def main():
    p = argparse.ArgumentParser(description="Sort a TSV by chr and start")
    p.add_argument('--input',  '-i', required=True, help="Input TSV file")
    p.add_argument('--output', '-o', required=True, help="Output (sorted) TSV file")
    args = p.parse_args()

    sorted_df = load_and_sort_tsv(args.input)
    sorted_df.to_csv(args.output, sep='\t', index=False)

if __name__ == "__main__":
    main()
