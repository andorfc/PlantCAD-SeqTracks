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
