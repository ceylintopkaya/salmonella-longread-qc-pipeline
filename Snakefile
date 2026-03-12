PYTHON = r"C:/Users/cylin/AppData/Local/Programs/Python/Python312/python.exe"
RSCRIPT = r"C:/Program Files/R/R-4.4.1/bin/Rscript.exe"

rule all:
    input:
        "results/nanoqc_report/nanoQC.html",
        "results/read_stats.csv",
        "results/summary_stats.csv",
        "results/report.xlsx",
        "results/summary_table.png",
        "results/qc_plots_python.png",
        "results/qc_plots_R.png"

rule nanoqc:
    input:
        fastq = "data/salmonella.fastq"
    output:
        "results/nanoqc_report/nanoQC.html"
    shell:
        "nanoqc -o results/nanoqc_report {input.fastq}"

rule analyze_reads:
    input:
        "data/salmonella.fastq"
    output:
        "results/read_stats.csv",
        "results/summary_stats.csv",
        "results/report.xlsx",
        "results/summary_table.png"
    shell:
        '"{PYTHON}" scripts/analyze_reads.py'

rule visualize_python:
    input:
        "results/read_stats.csv"
    output:
        "results/qc_plots_python.png"
    shell:
        '"{PYTHON}" scripts/visualize.py'

rule visualize_R:
    input:
        "results/read_stats.csv"
    output:
        "results/qc_plots_R.png"
    shell:
        '"{RSCRIPT}" scripts/visualize.R'