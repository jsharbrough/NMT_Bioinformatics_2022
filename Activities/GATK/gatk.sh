#!/bin/bash
#SBATCH --time=12:00:00
#SBATCH --partition=class
#SBATCH --mem=100G
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --cpus-per-task=1
#SBATCH --mail-user=email
#SBATCH --mail-type=ALL
#SBATCH --job-name=gatk
#SBATCH --error=gatk.err
#SBATCH --output=gatk.out


module load miniconda
module load gatk/4.1.2.0-gcc-8.2.0-tea36gs
eval "$(conda shell.bash hook)"
conda activate bio
gatk CreateSequenceDictionary -R DRR228447.miniasm.mtDNA.fasta
samtools faidx DRR228447.miniasm.mtDNA.fasta
gatk --java-options "-Xmx4g" MarkDuplicates --INPUT ERR104980.mtDNA.primary.sorted.bam --METRICS_FILE ERR104980.markedDups.txt --OUTPUT ERR104980.mtDNA.duplicatesRemoved.bam --READ_NAME_REGEX null --REMOVE_DUPLICATES true --REMOVE_SEQUENCING_DUPLICATES true --CREATE_INDEX false
gatk --java-options "-Xmx4g" AddOrReplaceReadGroups -I ERR104980.mtDNA.duplicatesRemoved.bam -O ERR104980.mtDNA.duplicatesRemoved.RGadded.bam -RGLB=lib1 -RGPL=illumina -RGPU=unit1 -RGSM=20
samtools index ERR104980.mtDNA.duplicatesRemoved.RGadded.bam
gatk --java-options "-Xmx4g" HaplotypeCaller --input ERR104980.mtDNA.duplicatesRemoved.RGadded.bam --output ERR104980.mtDNA.vcf --reference DRR228447.miniasm.mtDNA.fasta -ploidy 1

conda deactivate
