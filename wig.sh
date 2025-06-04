#!/bin/bash

INPUT="./info/information_content_sorted.tsv"
OUTPUT="./wig/genome"

python ic_scaled_wig.py -input $INPUT  -prefix $OUTPUT
