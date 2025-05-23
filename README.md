# PlantCAD-SeqTracks: Visualizing DNA Language Model Predictions in JBrowse 🧬

PlantCAD-SeqTracks is a bioinformatics workflow that leverages the PlantCaduceus DNA-language model to predict nucleotide probabilities around gene models. It then computes the information content (IC) from these probabilities to generate intuitive genomic tracks for visualization in JBrowse. This allows researchers to visually explore regions of functional importance, potential regulatory elements, and variant sites based on the model's understanding of DNA sequences.

---

## 📜 Overview

The core functionality of this workflow is to:
1.  Define genomic regions of interest (e.g., around gene models) from a GFF file.
2.  Extract the corresponding DNA sequences.
3.  Utilize the PlantCaduceus model to predict nucleotide probabilities for these sequences.
4.  Calculate Information Content (IC) and nucleotide-specific scores based on these predictions.
5.  Convert these scores into JBrowse-compatible track formats (WIG and BigWig).

This provides a powerful way to interpret the outputs of large DNA language models in a familiar genomic browser context.

---

## 📊 Workflow Steps

1.  **Generate BED files:** Create BED files defining regions around gene models from a provided GFF3 annotation file.
2.  **Extract genomic sequences:** Use BEDTools to extract DNA sequences for the regions defined in the BED files from a reference genome FASTA file.
3.  **Predict nucleotide probabilities:** Employ the PlantCaduceus model to perform zero-shot predictions of nucleotide probabilities for the extracted sequences.
4.  **Compile and calculate IC:** Concatenate prediction results and calculate Information Content (IC) and IC-weighted nucleotide scores.
5.  **Visualize in JBrowse:** Convert the calculated scores into WIG and BigWig formats for easy visualization as tracks in the JBrowse genome browser.

---

## 📁 Directory Structure
'''
PlantCAD-SeqTracks/
├── data/                   # Input data files
│   ├── genome.fa           # Reference genome FASTA file
│   └── annotation.gff3     # Gene annotation GFF3 file
├── bed/                    # Generated BED files defining regions of interest
├── predictions/            # Raw nucleotide probability predictions from PlantCaduceus
├── scripts/                # All executable scripts and environment file
│   ├── environment.yml     # Conda environment definition
│   ├── my_bed.sh           # Script to generate BED files from GFF (Assumed)
│   ├── extract_sequences.sh # Script to extract FASTA sequences using BEDTools
│   ├── zero_shot_score.sh  # Script to run PlantCaduceus predictions
│   ├── my_info.sh          # Script to calculate Information Content
│   ├── my_wig.sh           # Script to convert scores to WIG format
│   └── my_bigwig.sh        # Script to convert WIG to BigWig format
└── jbrowse_tracks/         # Final BigWig tracks for JBrowse
'''

---

## 🛠️ External Tools and Resources

This workflow relies on several external tools and resources:

* **BEDTools:** A powerful suite for genomic arithmetic.
    * Homepage: [https://bedtools.readthedocs.io](https://bedtools.readthedocs.io)
* **PlantCaduceus Model:** The DNA language model used for predictions.
    * GitHub Repository: [https://github.com/somervillLab/PlantCaduceus](https://github.com/somervillLab/PlantCaduceus) (Please update this link to the specific model repository if different)
    * Manuscript: [https://doi.org/10.1101/2024.06.04.596709](https://doi.org/10.1101/2024.06.04.596709)
* **JBrowse Genome Browser:** A fast, embeddable genome browser.
    * Homepage: [https://jbrowse.org](https://jbrowse.org)
* **Conda:** Package, dependency, and environment management.
    * Homepage: [https://docs.conda.io/](https://docs.conda.io/)

---

## 🚀 Quick Start

Follow these steps to run the PlantCAD-SeqTracks workflow:

### Step 0: Environment Setup

1.  **Clone the repository (Example):**
    ```bash
    git clone [https://github.com/your-username/PlantCAD-SeqTracks.git](https://github.com/your-username/PlantCAD-SeqTracks.git)
    cd PlantCAD-SeqTracks
    ```

2.  **Create and activate the Conda environment:**
    The `scripts/environment.yml` file should define the necessary dependencies. If it's not already created, you can create it with the following content:
    ```yaml
    # scripts/environment.yml
    name: dnalogo
    channels:
      - bioconda
      - conda-forge
      - defaults
    dependencies:
      - python=3.10
      - pandas
      - bedtools
      # Add any other specific dependencies for PlantCaduceus or your scripts
    ```
    Then, create the environment:
    ```bash
    conda env create -f scripts/environment.yml
    conda activate dnalogo
    ```
    Alternatively, if `environment.yml` is not provided, you can create the environment with essential tools:
    ```bash
    conda create -n dnalogo python=3.10 pandas bedtools -c bioconda -c conda-forge -y
    conda activate dnalogo
    ```
3.  **Ensure PlantCaduceus is installed and accessible.** Follow the installation instructions from the [PlantCaduceus GitHub repository](https://github.com/somervillLab/PlantCaduceus). The `zero_shot_score.sh` script will need to be able to call the PlantCaduceus prediction tools.

### Step 1: Data Download & Preparation

1.  **Download example maize datasets** (or use your own `genome.fa` and `annotation.gff3`):
    Place your genome FASTA (`genome.fa`) and annotation GFF3 (`annotation.gff3`) files into the `data/` directory.
    For the example:
    ```bash
    mkdir -p data
    wget [https://download.maizegdb.org/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3.gz](https://download.maizegdb.org/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3.gz) -O data/annotation.gff3.gz
    gunzip data/annotation.gff3.gz
    wget [https://download.maizegdb.org/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0.fa.gz](https://download.maizegdb.org/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0.fa.gz) -O data/genome.fa.gz
    gunzip data/genome.fa.gz
    ```
    Ensure your `genome.fa` file is indexed by SAMtools (`samtools faidx data/genome.fa`) if your BEDTools version requires it for sequence extraction.

### Step 2: Generate BED Files and Extract Sequences

1.  **Generate BED files from your GFF3 annotation:**
    The `my_bed.sh` script is responsible for creating BED files that define the regions of interest (e.g., 1kb upstream and downstream of genes) from `data/annotation.gff3`. You will need to create or adapt this script for your specific needs.
    Example placeholder for `scripts/my_bed.sh` (you'll need to customize this):
    ```bash
    #!/bin/bash
    # This is a placeholder script.
    # You need to implement the logic to generate BED files from data/annotation.gff3
    # For example, to get regions 1kb upstream and downstream of genes:
    # awk -F'\t' '$3 == "gene" {print $1, $4-1000, $5+1000, $9, ".", $7}' data/annotation.gff3 | sed 's/ID=[^;]*;//' > bed/gene_regions.bed
    echo "Generating BED files... (Customize my_bed.sh)"
    # Ensure the bed/ directory exists
    mkdir -p bed
    # Your BED generation commands here, e.g., outputting to bed/my_regions.bed
    ```
    Make it executable: `chmod +x scripts/my_bed.sh`
    Run the script (example using `sbatch` if on a cluster, or `bash` locally):
    ```bash
    # sbatch scripts/my_bed.sh
    # OR
    bash scripts/my_bed.sh
    ```
    *Note: The `sbatch` command implies a SLURM scheduler. Adjust accordingly if you are using a different job scheduler or running locally.*

2.  **Extract genomic sequences using BEDTools:**
    This script uses the BED files generated in the previous step and the reference genome to extract FASTA sequences.
    Ensure `scripts/extract_sequences.sh` is configured to use your generated BED files and `data/genome.fa`.
    Example content for `scripts/extract_sequences.sh` (customize as needed):
    ```bash
    #!/bin/bash
    GENOME_FA="data/genome.fa"
    BED_DIR="bed"
    OUTPUT_DIR="sequences" # Or directly to a file used by zero_shot_score.sh

    mkdir -p ${OUTPUT_DIR}

    # Example: process each bed file in the bed directory
    for bed_file in ${BED_DIR}/*.bed; do
        filename=$(basename -- "$bed_file")
        output_fasta="${OUTPUT_DIR}/${filename%.bed}.fasta"
        echo "Extracting sequences for ${bed_file} to ${output_fasta}"
        bedtools getfasta -fi "${GENOME_FA}" -bed "${bed_file}" -fo "${output_fasta}"
    done

    echo "Sequence extraction complete."
    ```
    Make it executable: `chmod +x scripts/extract_sequences.sh`
    Run the script:
    ```bash
    bash scripts/extract_sequences.sh
    ```

### Step 3: Predict Nucleotide Probabilities

Run the PlantCaduceus model to predict nucleotide probabilities for the extracted sequences.
The `zero_shot_score.sh` script should be configured to take the FASTA files (from Step 2) as input and output prediction files (e.g., TSV format) into the `predictions/` directory.
```bash
mkdir -p predictions
# Ensure zero_shot_score.sh points to your PlantCaduceus installation and input sequences
bash scripts/zero_shot_score.sh

