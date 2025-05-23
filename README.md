# UNDER CONSTRUCTION

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
```text
PlantCAD-SeqTracks/
├── data/                   # Input data files
│   ├── genome.fa           # Reference genome FASTA file
│   └── annotation.gff3     # Gene annotation GFF3 file
|
├── environment.yml         # Conda environment definition
|
├── my_bed.sh               # Script to generate BED files from GFF (Assumed)
|
├── extract_sequences.sh    # Script to extract FASTA sequences using BEDTools
|
├── bed/                    # Generated BED files defining regions of interest
├── predictions/            # Raw nucleotide probability predictions from PlantCaduceus
├── scripts/                # All executable scripts and environment file
│   ├── generate_bed_files.py           # Python code to generate BED files from GFF (Assumed)
|   | 
│   ├── zero_shot_score.sh  # Script to run PlantCaduceus predictions
│   ├── my_info.sh          # Script to calculate Information Content
│   ├── my_wig.sh           # Script to convert scores to WIG format
│   └── my_bigwig.sh        # Script to convert WIG to BigWig format
└── jbrowse_tracks/         # Final BigWig tracks for JBrowse
```

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
    git clone https://github.com/your-username/PlantCAD-SeqTracks.git
    cd PlantCAD-SeqTracks
    ```

2.  **Create and activate the Conda environment:**
    The `environment.yml` file defines the necessary dependencies. 

    create the environment:
    ```bash
    conda env create -f environment.yml
    conda activate pytorch_pc
    ```
    
3.  **Ensure PlantCaduceus is installed and accessible.** Follow the installation instructions from the [PlantCaduceus GitHub repository](https://github.com/somervillLab/PlantCaduceus). The `zero_shot_score.sh` script will need to be able to call the PlantCaduceus prediction tools.

### Step 1: Data Download & Preparation

1.  **Download example maize datasets** (or use your own `genome.fa` and `annotation.gff3`):
    Place your genome FASTA (`genome.fa`) and annotation GFF3 (`annotation.gff3`) files into the `data/` directory.
    For the example:
    ```bash
    mkdir -p data
    wget https://download.maizegdb.org/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0_Zm00001eb.1.gff3.gz -O data/annotation.gff3.gz
    gunzip data/annotation.gff3.gz
    wget https://download.maizegdb.org/Zm-B73-REFERENCE-NAM-5.0/Zm-B73-REFERENCE-NAM-5.0.fa.gz -O data/genome.fa.gz
    gunzip data/genome.fa.gz
    ```
    Ensure your `genome.fa` file is indexed by SAMtools (`samtools faidx data/genome.fa`) if your BEDTools version requires it for sequence extraction.

### Step 2: Generate BED Files and Extract Sequences

1.  **Generate BED files from your GFF3 annotation:**
    The `my_bed.sh` script is responsible for creating BED files that define the regions of interest (e.g., 1kb upstream and downstream of genes) from `data/annotation.gff3`. You will need to create or adapt this script for your specific needs.
    
    Make it executable: `chmod +x scripts/my_bed.sh`
    Run the script (example using `sbatch` if on a cluster, or `bash` locally):
    ```bash
    # sbatch scripts/my_bed.sh
    # OR
    bash scripts/my_bed.sh
    ```
    *Note: The `sbatch` command implies a SLURM scheduler. Adjust accordingly if you are using a different job scheduler or running locally.*

2.  **Extract genomic sequences using BEDTools:**
    This script uses the BED files generated in the previous step and the reference genome to extract FASTA sequences using bedtools (installation required).
    Ensure `scripts/extract_sequences.sh` is configured to use your generated BED files and `data/genome.fa`.

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
 ```

### Step 4: Concatenate Predictions

Combine individual prediction files (if PlantCaduceus outputs multiple files) into a single file for easier processing.

```bash
cat predictions/predictions_*.tsv > predictions/all_predictions.tsv
```

Adjust predictions_*.tsv pattern based on your output from zero_shot_score.sh.

### Step 5: Calculate Information Content
Use my_info.sh to calculate Information Content (IC) and other derived scores from predictions/all_predictions.tsv. The output might be one or more files ready for WIG conversion.

```bash
scripts/my_info.sh
```
This script will need to implement the formulas below and produce output files (e.g., in a format easily convertible to WIG) that contain per-base scores for each track type described in "Example Output Tracks".

### Step 6: Create JBrowse Tracks
Convert the calculated scores into WIG and then BigWig formats for JBrowse.
Ensure my_wig.sh and my_bigwig.sh are configured to find the output from my_info.sh and have access to tools like wigToBigWig (often available via UCSC Kent utils).

Prepare a chrom.sizes file:
This file contains the names and lengths of the chromosomes in your reference genome. It's required by wigToBigWig. You can create it from your FASTA index:

```bash
samtools faidx data/genome.fa
cut -f1,2 data/genome.fa.fai > data/genome.chrom.sizes
```

Run the conversion scripts:
```bash
mkdir -p jbrowse_tracks
bash scripts/my_wig.sh # This script should convert outputs from my_info.sh to .wig files
bash scripts/my_bigwig.sh # This script should convert .wig files to .bw (BigWig) using genome.chrom.sizes
Example my_wig.sh might iterate through output files from my_info.sh, formatting them into WIG. Example my_bigwig.sh would then iterate through these WIG files and use wigToBigWig.
```

## 🧪 Formulas Used

### Information Content (IC)

The Information Content at each position is calculated to measure the certainty of the prediction. It ranges from 0 (all nucleotides equally probable) to 2 bits (one nucleotide is predicted with 100% probability).

The formula for IC is:
$$IC = 2 + \sum_{b \in \{A,C,G,T\}} p_b \times \log_2(p_b)$$

Where $p_b$ is the predicted probability of nucleotide $b$ at that position. 

If $p_b = 0$, then $p_b \times \log_2(p_b) = 0$.

### Nucleotide Heights for Visualization (IC-Weighted Probabilities)

For visualization (e.g., in sequence logos or height-scaled tracks), the height of each nucleotide can be represented as its probability weighted by the IC at that position:

$A_{height} = IC \times prob(A)$

$C_{height} = IC \times prob(C)$

$G_{height} = IC \times prob(G)$

$T_{height} = IC \times prob(T)$

## 🖼️ Example Output Tracks

The workflow generates several types of tracks for visualization in JBrowse:

* **`PlantCAD_A_IC_weighted.bw`**: IC-weighted probability for Adenine ($A_{height}$).
* **`PlantCAD_C_IC_weighted.bw`**: IC-weighted probability for Cytosine ($C_{height}$).
* **`PlantCAD_G_IC_weighted.bw`**: IC-weighted probability for Guanine ($G_{height}$).
* **`PlantCAD_T_IC_weighted.bw`**: IC-weighted probability for Thymine ($T_{height}$).
    * *These four separate tracks highlight positions where specific nucleotides are strongly predicted.*
* **`PlantCAD_IC_summary.bw`**: A single track showing the highest IC-weighted nucleotide score (max of $A_{height}, C_{height}, G_{height}, T_{height}$) at each genomic position. This gives an overview of the most "important" predicted nucleotide.
* **`PlantCAD_Information_Content.bw`**: A track displaying the raw IC score (0 to 2 bits) at each genomic position, indicating the overall certainty or conservation of the prediction.
* **`PlantCAD_Ref_Allele_IC_weighted.bw`**: A track showing the IC-weighted predicted probability for the nucleotide that is present in the reference genome at each position. This can highlight how well the model's prediction aligns with the reference.
* **`PlantCAD_Top_Alt_Allele_IC_weighted.bw`**: A track showing the IC-weighted predicted probability for the *highest-scoring non-reference* nucleotide. This can help identify potential variant sites where the model strongly predicts an alternative allele.

*(Actual filenames in `jbrowse_tracks/` will depend on your `my_bigwig.sh` script.)*

## 👁️ Visualization

The generated BigWig tracks can be loaded into any JBrowse instance (JBrowse 1, JBrowse 2, or JBrowse Web).

* High IC peaks in the `PlantCAD_Information_Content.bw` track indicate positions that the model predicts with high certainty, often corresponding to conserved and functionally significant positions.
* Nucleotide-specific IC-Weighted tracks (e.g., `PlantCAD_A_IC_weighted.bw`) can help identify potential regulatory motifs (e.g., a region with consistently high $A_{height}$ and $T_{height}$ scores might indicate an AT-rich motif).
* The `PlantCAD_Top_Alt_Allele_IC_weighted.bw` track can guide the discovery of interesting SNPs or small indels where the model diverges from the reference genome with high confidence.

By overlaying these tracks with gene annotations, experimental data (e.g., ChIP-seq, RNA-seq), and variant calls, users can gain deeper insights into the genomic landscape as interpreted by the PlantCaduceus model.

## 📚 Citations

If you use this workflow or the PlantCaduceus model in your research, please cite:

* **PlantCaduceus Manuscript:** [https://doi.org/10.1101/2024.06.04.596709](https://doi.org/10.1101/2024.06.04.596709)
* **This GitHub Repository (Example):** `https://github.com/your-username/PlantCAD-SeqTracks` (Update with your actual repository link once created)

Please also cite the tools used within the workflow:

* **BEDTools:** Quinlan AR, Hall IM. BEDTools: a flexible suite of utilities for comparing genomic features. Bioinformatics. 2010 Mar 15;26(6):841-2. ([https://bedtools.readthedocs.io](https://bedtools.readthedocs.io))
* **JBrowse:** Buels R, et al. JBrowse: a dynamic web platform for genome visualization and analysis. Genome Biology. 2016;17:66. ([https://jbrowse.org](https://jbrowse.org))
* **SAMtools** (if used for indexing/`faidx`): Li H, et al. The Sequence Alignment/Map format and SAMtools. Bioinformatics. 2009 Aug 15;25(16):2078-9. ([http://www.htslib.org/](http://www.htslib.org/))
* **UCSC Kent Utilities** (for `wigToBigWig`): Kent WJ, et al. BigWig and BigBed: enabling Browse of large distributed datasets. Bioinformatics. 2010 Sep 1;26(17):2204-7. ([http://hgdownload.soe.ucsc.edu/admin/exe/](http://hgdownload.soe.ucsc.edu/admin/exe/))

## 📞 Contact

For questions, bug reports, or feature requests, please create an issue in this GitHub repository.
Alternatively, you can contact the authors directly (e.g., `Carson Andorf <carson.andorf@usda.gov>`).

