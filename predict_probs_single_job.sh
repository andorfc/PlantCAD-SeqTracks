#!/bin/bash -l
#SBATCH --partition=gpu             # Partition to submit the job (using GPU and cuda)
#SBATCH --job-name=PlantCAD         # Name of the job
#SBATCH --gres=gpu:1                # Request 1 GPU resource

module load miniconda3
module load cuda
source activate pytorch_pc

NN=$1

MODEL="kuleshov-group/PlantCaduceus_l32"

INPUT="./inputs/sequences_${NN}.tsv"
OUTPUT="./predictions_test/predictions_${NN}.tsv"

python zero_shot_probabilities.py -input $INPUT -output $OUTPUT -model $MODEL -device 'cuda'
