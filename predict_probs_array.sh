#!/bin/bash -l
#SBATCH --partition=gpu             # Partition to submit the job (using GPU and cuda)
#SBATCH --job-name=PlantCAD         # Name of the job
#SBATCH --gres=gpu:1                # Request 1 GPU resource
#SBATCH --array=0-4000%10           # Hard code the number of sequence files, e.g., 0–400, max 10 concurrent

module load miniconda3
module load cuda
source activate pytorch_pc

# Use array index instead of positional arg
NN=${SLURM_ARRAY_TASK_ID}

INPUT="./inputs_minus/sequences_${NN}.tsv"
OUTPUT="./predictions_minus_5k/predictions_${NN}.tsv"
MODEL="kuleshov-group/PlantCaduceus_l32"

echo "Processing array task ${NN}"
echo "Input : ${INPUT}"
echo "Output: ${OUTPUT}"

python zero_shot_probabilities.py \
  -input  "${INPUT}" \
  -output "${OUTPUT}" \
  -model  "${MODEL}" \
  -device 'cuda'
