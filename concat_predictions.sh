#!/bin/bash

DIR_NAME="./predictions/"
OUT_NAME="./final_predictions/predictions.tsv"

# Pick one file to grab the header from
first_file=$(ls ${DIR_NAME}/*.tsv | head -n 1)

# Write its header to the output
head -n 1 "$first_file" > ${OUT_NAME}

# Append data (skip header) from every file
for f in ${DIR_NAME}/*.tsv; do
    tail -n +2 "$f" >> ${OUT_NAME}
done
