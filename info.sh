#!/bin/bash

INPUT="./final_predictions/predictions.tsv"
OUTPUT="./info/information_content.tsv"
FINAL_OUTPUT="./info/information_content_sorted.tsv"

python probs_to_ic_fast.py -input $INPUT -output $OUTPUT
python sort_info.py --input $OUTPUT --output $FINAL_OUTPUT
