#!/bin/bash

module load kentutils

INPUT="./wig/genome_"
OUTPUT="./bigwig/genome_"

if true; then
    awk '
    # ─── When we encounter a new chromosome header ──────────────────────────────
    /^variableStep/ {                     # e.g. “variableStep chrom=chr1 span=1”
        print;                            # keep the header
        delete seen;                      # forget all previous coordinates
        next;
    }

    # ─── Any other non‑numeric header lines (e.g. comments) ─────────────────────
    $1 !~ /^[0-9]/ { print; next }

    # ─── Numeric data lines: print only the first time we see this position ─────
    !seen[$1]++                           # $1 is the genomic coordinate
    ' ${INPUT}A_scaled.wig > ${INPUT}A_scaled_unique.wig

    awk '
    # ─── When we encounter a new chromosome header ──────────────────────────────
    /^variableStep/ {                     # e.g. “variableStep chrom=chr1 span=1”
        print;                            # keep the header
        delete seen;                      # forget all previous coordinates
        next;
    }

    # ─── Any other non‑numeric header lines (e.g. comments) ─────────────────────
    $1 !~ /^[0-9]/ { print; next }

    # ─── Numeric data lines: print only the first time we see this position ─────
    !seen[$1]++                           # $1 is the genomic coordinate
    ' ${INPUT}G_scaled.wig > ${INPUT}G_scaled_unique.wig

    awk '
    # ─── When we encounter a new chromosome header ──────────────────────────────
    /^variableStep/ {                     # e.g. “variableStep chrom=chr1 span=1”
        print;                            # keep the header
        delete seen;                      # forget all previous coordinates
        next;
    }

    # ─── Any other non‑numeric header lines (e.g. comments) ─────────────────────
    $1 !~ /^[0-9]/ { print; next }

    # ─── Numeric data lines: print only the first time we see this position ─────
    !seen[$1]++                           # $1 is the genomic coordinate
    ' ${INPUT}C_scaled.wig > ${INPUT}C_scaled_unique.wig

    awk '
    # ─── When we encounter a new chromosome header ──────────────────────────────
    /^variableStep/ {                     # e.g. “variableStep chrom=chr1 span=1”
        print;                            # keep the header
        delete seen;                      # forget all previous coordinates
        next;
    }

    # ─── Any other non‑numeric header lines (e.g. comments) ─────────────────────
    $1 !~ /^[0-9]/ { print; next }

    # ─── Numeric data lines: print only the first time we see this position ─────
    !seen[$1]++                           # $1 is the genomic coordinate
    ' ${INPUT}T_scaled.wig > ${INPUT}T_scaled_unique.wig

    awk '
    # ─── When we encounter a new chromosome header ──────────────────────────────
    /^variableStep/ {                     # e.g. “variableStep chrom=chr1 span=1”
        print;                            # keep the header
        delete seen;                      # forget all previous coordinates
        next;
    }

    # ─── Any other non‑numeric header lines (e.g. comments) ─────────────────────
    $1 !~ /^[0-9]/ { print; next }

    # ─── Numeric data lines: print only the first time we see this position ─────
    !seen[$1]++                           # $1 is the genomic coordinate
    ' ${INPUT}reference.wig > ${INPUT}reference_unique.wig

    awk '
    # ─── When we encounter a new chromosome header ──────────────────────────────
    /^variableStep/ {                     # e.g. “variableStep chrom=chr1 span=1”
        print;                            # keep the header
        delete seen;                      # forget all previous coordinates
        next;
    }

    # ─── Any other non‑numeric header lines (e.g. comments) ─────────────────────
    $1 !~ /^[0-9]/ { print; next }

    # ─── Numeric data lines: print only the first time we see this position ─────
    !seen[$1]++                           # $1 is the genomic coordinate
    ' ${INPUT}nonreference.wig > ${INPUT}nonreference_unique.wig

    awk '
    # ─── When we encounter a new chromosome header ──────────────────────────────
    /^variableStep/ {                     # e.g. “variableStep chrom=chr1 span=1”
        print;                            # keep the header
        delete seen;                      # forget all previous coordinates
        next;
    }

    # ─── Any other non‑numeric header lines (e.g. comments) ─────────────────────
    $1 !~ /^[0-9]/ { print; next }

    # ─── Numeric data lines: print only the first time we see this position ─────
    !seen[$1]++                           # $1 is the genomic coordinate
    ' ${INPUT}information.wig > ${INPUT}information_unique.wig

    # ─── Any other non‑numeric header lines (e.g. comments) ─────────────────────
    $1 !~ /^[0-9]/ { print; next }

    # ─── Numeric data lines: print only the first time we see this position ─────
    !seen[$1]++                           # $1 is the genomic coordinate
    ' ${INPUT}delta.wig > ${INPUT}delta_unique.wig
fi

if true; then

awk '
  # If this is a variableStep header for a chromosome → turn keep on & print it
  /^variableStep chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is a fixedStep  header for a chromosome → turn keep on & print it
  /^fixedStep    chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is any other header (i.e. scaffold or something else) → turn keep off
  /^(variableStep|fixedStep)/        { keep=0; next }
  # Otherwise, print the line only if keep is on
  keep                                { print }
' ${INPUT}A_scaled_unique.wig > ${INPUT}A_scaled_chrs.wig

awk '
  # If this is a variableStep header for a chromosome → turn keep on & print it
  /^variableStep chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is a fixedStep  header for a chromosome → turn keep on & print it
  /^fixedStep    chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is any other header (i.e. scaffold or something else) → turn keep off
  /^(variableStep|fixedStep)/        { keep=0; next }
  # Otherwise, print the line only if keep is on
  keep                                { print }
' ${INPUT}G_scaled_unique.wig > ${INPUT}G_scaled_chrs.wig

awk '
  # If this is a variableStep header for a chromosome → turn keep on & print it
  /^variableStep chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is a fixedStep  header for a chromosome → turn keep on & print it
  /^fixedStep    chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is any other header (i.e. scaffold or something else) → turn keep off
  /^(variableStep|fixedStep)/        { keep=0; next }
  # Otherwise, print the line only if keep is on
  keep                                { print }
' ${INPUT}C_scaled_unique.wig > ${INPUT}C_scaled_chrs.wig


awk '
  # If this is a variableStep header for a chromosome → turn keep on & print it
  /^variableStep chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is a fixedStep  header for a chromosome → turn keep on & print it
  /^fixedStep    chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is any other header (i.e. scaffold or something else) → turn keep off
  /^(variableStep|fixedStep)/        { keep=0; next }
  # Otherwise, print the line only if keep is on
  keep                                { print }
' ${INPUT}T_scaled_unique.wig > ${INPUT}T_scaled_chrs.wig

awk '
  # If this is a variableStep header for a chromosome → turn keep on & print it
  /^variableStep chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is a fixedStep  header for a chromosome → turn keep on & print it
  /^fixedStep    chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is any other header (i.e. scaffold or something else) → turn keep off
  /^(variableStep|fixedStep)/        { keep=0; next }
  # Otherwise, print the line only if keep is on
  keep                                { print }
' ${INPUT}nonreference_unique.wig > ${INPUT}nonreference_chrs.wig

awk '
  # If this is a variableStep header for a chromosome → turn keep on & print it
  /^variableStep chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is a fixedStep  header for a chromosome → turn keep on & print it
  /^fixedStep    chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is any other header (i.e. scaffold or something else) → turn keep off
  /^(variableStep|fixedStep)/        { keep=0; next }
  # Otherwise, print the line only if keep is on
  keep                                { print }
' ${INPUT}reference_unique.wig  > ${INPUT}reference_chrs.wig

awk '
  # If this is a variableStep header for a chromosome → turn keep on & print it
  /^variableStep chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is a fixedStep  header for a chromosome → turn keep on & print it
  /^fixedStep    chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is any other header (i.e. scaffold or something else) → turn keep off
  /^(variableStep|fixedStep)/        { keep=0; next }
  # Otherwise, print the line only if keep is on
  keep                                { print }
' ${INPUT}information_unique.wig > ${INPUT}information_chrs.wig

awk '
  # If this is a variableStep header for a chromosome → turn keep on & print it
  /^variableStep chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is a fixedStep  header for a chromosome → turn keep on & print it
  /^fixedStep    chrom=chr[0-9XYM]+/ { keep=1; print; next }
  # If this is any other header (i.e. scaffold or something else) → turn keep off
  /^(variableStep|fixedStep)/        { keep=0; next }
  # Otherwise, print the line only if keep is on
  keep                                { print }
' ${INPUT}delta_unique.wig > ${INPUT}delta_chrs.wig

fi

#Rename as you see fit
if true; then
    wigToBigWig ${INPUT}A_scaled_chrs.wig chrom.sizes ${OUTPUT}A.bw
    wigToBigWig ${INPUT}G_scaled_chrs.wig chrom.sizes ${OUTPUT}G.bw
    wigToBigWig ${INPUT}C_scaled_chrs.wig chrom.sizes ${OUTPUT}C.bw
    wigToBigWig ${INPUT}T_scaled_chrs.wig chrom.sizes ${OUTPUT}T.bw
    wigToBigWig ${INPUT}nonreference_chrs.wig chrom.sizes ${OUTPUT}nonreference.bw
    wigToBigWig ${INPUT}reference_chrs.wig chrom.sizes ${OUTPUT}reference.bw
    wigToBigWig ${INPUT}information_chrs.wig chrom.sizes ${OUTPUT}information.bw
    wigToBigWig ${INPUT}delta_chrs.wig chrom.sizes ${OUTPUT}delta.bw
fi
