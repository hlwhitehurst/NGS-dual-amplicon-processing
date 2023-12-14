#!/bin/bash
#SBATCH --job-name=fastqcGeneration
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=12gb
#SBATCH --time=8:00:00

cd /path/to/fastq/files/01SeqOutput
mkdir fastqc-reports

module purge
module load fastqc/0.11.9

for i in *fastq.gz
do
fastqc $i -o fastqc-reports
done