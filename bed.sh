#!/bin/bash

INPUT="./data/annotation.gff3"
OUTPUT="./bed/"

mkdir -p bed

python ./python/generate_bed_files.py --gff $INPUT --output_dir $OUTPUT --genes_per_file 200 --padding 1000
