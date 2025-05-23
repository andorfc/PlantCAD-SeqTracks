import argparse
import pandas as pd

def parse_args():
    parser = argparse.ArgumentParser(description='Create BED files from GFF.')
    parser.add_argument('--gff', required=True, help='Input GFF file')
    parser.add_argument('--output_dir', required=True, help='Output directory for BED files')
    parser.add_argument('--test', action='store_true', help='Generate files for only the first 10 genes')
    parser.add_argument('--genes_per_file', type=int, default=200,
                        help='Number of genes to include in each BED file (default: 200)')
    parser.add_argument('--padding', type=int, default=1000,
                        help='Padding (bp) to add upstream/downstream of each gene (default: 1000)')
    return parser.parse_args()

args = parse_args()

# Load GFF with defined column names
gff_cols = ['chr', 'source', 'type', 'start', 'end', 'score', 'strand', 'phase', 'attributes']
gff_df = pd.read_csv(args.gff, sep='\t', comment='#', names=gff_cols)

# Filter for gene rows
genes_df = gff_df[gff_df['type'] == 'gene'].reset_index(drop=True)

if args.test:
    genes_df = genes_df.head(10)

for i in range(0, len(genes_df), args.genes_per_file):
    subset = genes_df.iloc[i:i + args.genes_per_file]
    bed_rows = []
    for _, row in subset.iterrows():
        # Calculate center position
        center = (row['start'] + row['end']) // 2

        # Extract the gene model ID
        gene_model = next((attr.split('ID=')[1]
                           for attr in row['attributes'].split(';')
                           if attr.startswith('ID=')),
                          row['attributes'])

        # Apply padding
        begin = row['start'] - args.padding
        end   = row['end']   + args.padding

        # Create BED entries by iterating through positions around the center
        for pos in range(begin - 1, end - 1):
            start_bed = pos - 256  # 0-based BED start
            end_bed   = pos + 256
            bed_rows.append([row['chr'], start_bed, end_bed, gene_model])

    # Write out one BED file per chunk
    bed_df = pd.DataFrame(bed_rows, columns=['chr', 'start', 'end', 'gene_model'])
    outfile = f"{args.output_dir}/genes_{i//args.genes_per_file}.bed"
    bed_df.to_csv(outfile, sep='\t', index=False, header=False)
    print(f"Wrote {len(subset)} genes → {outfile}")
