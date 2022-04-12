#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --partition=class
#SBATCH --mem=100G
#SBATCH --mail-user=email
#SBATCH --mail-type=ALL
#SBATCH --job-name=fastq-dump
#SBATCH --error=download_reads.err
#SBATCH --output=download_reads.out


module load miniconda
eval "$(conda shell.bash hook)"
conda activate bio
fastq-dump --origfmt --split-files --clip --gzip ERR104980
conda deactivate
