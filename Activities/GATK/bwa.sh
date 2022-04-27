#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --partition=class
#SBATCH --mem=100G
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=email
#SBATCH --mail-type=ALL
#SBATCH --job-name=bwa
#SBATCH --error=bwa.err
#SBATCH --output=bwa.out


module purge
module load miniconda
eval "$(conda shell.bash hook)"
conda activate bio
bwa index DRR228447.miniasm.mtDNA.fasta
bwa mem -t 12 DRR228447.miniasm.mtDNA.fasta ERR104980_1.fastq.gz ERR104980_2.fastq.gz > ERR104980.mtDNA.sam
samtools view -hbf 3 ERR104980.mtDNA.sam > ERR104980.mtDNA.primary.bam
samtools sort -@ 12 ERR104980.mtDNA.primary.bam > ERR104980.mtDNA.primary.sorted.bam
samtools index ERR104980.mtDNA.primary.sorted.bam
samtools flagstat ERR104980.mtDNA.primary.sorted.bam
conda deactivate
