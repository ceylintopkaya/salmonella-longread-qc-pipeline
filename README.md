# Mini Bioinformatics Pipeline for Long-Read QC

## Overview

This project implements a reproducible bioinformatics pipeline for performing quality control (QC) on long-read sequencing data.

The pipeline takes a FASTQ file as input and performs the following steps:

- Calculates read-level statistics:
  - GC content
  - Read length
  - Mean quality score
- Generates summary statistics
- Creates visualizations of key sequencing metrics

The workflow is implemented using Snakemake and runs inside a Conda environment to ensure reproducibility.

---

## Results Summary

| Metric             | Value                          |
|--------------------|--------------------------------|
| Total Reads        | 7,238                          |
| Mean Read Length   | 3,342 bp                       |
| Median Read Length | 3,304 bp                       |
| N50                | 3,612 bp                       |
| Mean GC Content    | 51.8%                          |
| Mean Quality Score | 33.4 (Q33.4 = 99.95% accuracy) |

---

## Visualization Gallery

| Plot File             | Plot Types                  | Description                                                                 |
|-----------------------|-----------------------------|-----------------------------------------------------------------------------|
| qc_plots_python.png   | 3 Histograms + 1 Scatter    | Read length, quality score, GC content distributions + length vs quality scatter |
| qc_plots_R.png        | Density + Boxplot + Violin  | Alternative visualizations of the same metrics                              |

---

## Project Structure

```
bioinfo-pipeline
│
├── Snakefile
├── environment.yml
├── README.md
│
├── data
│   └── salmonella.fastq
│
├── scripts
│   ├── analyze_reads.py
│   ├── visualize.py
│   └── visualize.R
│
└── results
```

---

## Requirements

- Conda / Miniconda
- Snakemake

All required dependencies are defined in the environment.yml file.

---

## Installation

```
conda env create -f environment.yml
conda activate bioinfo-pipeline
```

---

## Running the Pipeline

Preview the workflow:
```
snakemake -n
```

Run the pipeline:
```
snakemake --cores 1
```

---

## Output Files

| File                | Description                        |
|---------------------|------------------------------------|
| read_stats.csv      | Read-level statistics              |
| summary_stats.csv   | Summary statistics                 |
| report.xlsx         | Excel report                       |
| qc_plots_python.png | QC plots generated with Python     |
| qc_plots_R.png      | QC plots generated with R          |

---

## Methods

- Python (Biopython, Pandas) — calculates read-level statistics
- Python (Matplotlib, Seaborn) — generates visualizations
- R (ggplot2, gridExtra) — additional graphical summaries
- Snakemake — workflow automation and reproducibility

---

## Interpretation

The sequencing dataset shows expected read lengths, GC content consistent with Salmonella, and high sequencing quality (mean Q33.4).

- Read lengths: Mean 3,342 bp, N50 3,612 bp — typical for Nanopore sequencing
- GC content: 51.8% — consistent with Salmonella genome composition
- Quality scores: Mean Q33.4 (99.95% accuracy) — well above acceptable threshold

The Python plots show distributions with key markers (N50, Q10 threshold, expected GC). The R plots provide alternative visualizations (density, boxplot, violin) for the same metrics.

Overall, the data shows stable read length distribution, expected GC content, and high base-calling quality — suitable for downstream analysis.

---

## Recommendation

Based on the QC results, the next recommended step is alignment to a reference genome using a long-read aligner such as Minimap2.

---

## Repository

GitHub: https://github.com/ceylintopkaya/bioinfo-pipeline

---

## Author

Ceylin Topkaya
