#!/bin/bash
#SBATCH --job-name=multiqcGeneration
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem=12gb
#SBATCH --time=2:00:00

cd /path/to/directory/01SeqOutput/fastqc-reports/

module purge
module load multiqc/1.9

multiqc .

module unload multiqc/1.9