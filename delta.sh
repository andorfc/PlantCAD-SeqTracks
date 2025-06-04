#!/bin/bash

module load miniconda3

INPUT_REFERENCE="./wig/genome_reference.wig"
INPUT_NONREFERENCE="./wig/genome_nonreference.wig"
OUTPUT="./wig/genome_delta.wig"

python calc_delta_icp.py  ${INPUT_REFERENCE} ${INPUT_NONREFERENCE} ${OUTPUT}

#rm temp_${SLURM_ARRAY_TASK_ID}.tsv
