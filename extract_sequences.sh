#!/bin/bash

set -euo pipefail

module load bedtools2

BEDFILES="./bed/genes_*.bed"
FASTA="./fasta/genome.fa"
OUTDIR="./inputs/"

mkdir -p ./temp ./inputs

for BEDFILE in ${BEDFILES}; do
    # extract the numeric ID (e.g. from genes_3.bed → 3)
    BASENAME=$(basename "$BEDFILE" .bed)
    ID=${BASENAME#genes_}

    TEMP="./temp/temp_${ID}.tsv"
    OUTFILE="${OUTDIR}/sequences_${ID}.tsv"

    echo "Processing ${BEDFILE} → ${OUTFILE}..."

    bedtools getfasta \
        -fi "$FASTA" \
        -bed "$BEDFILE" \
        -tab \
        -name \
        -fo "$TEMP"

    paste "$BEDFILE" "$TEMP" | \
    awk 'BEGIN{OFS="\t"}
         {
           # $4 = gene_model, $1=chr, $2=start, $6=sequence
           print $4,
                 $1,
                 ($2 + 256),
                 substr($6, 256, 1),
                 $6
         }' > "$OUTFILE"
done

echo "All done!"
