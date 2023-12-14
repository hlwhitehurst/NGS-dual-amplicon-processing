#!/bin/bash
# We request a compute nodes with 16 CPUs and 32 GB of memory, and at
# most 24 hours of runtime.

#!/bin/bash
#SBATCH --job-name=sorting
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32GB
#SBATCH --time=01:00:00

#Here we seperate all reads whose ends map to the gyrB primers.

cd /path/to/directory/

module purge
module load bbtools/38.91

#MAKE DIRECTORIES FOR OUTPUT
mkdir -p ./02AmpliconSorted/16S
mkdir -p ./02AmpliconSorted/gyrB

cd /path/to/directory/01SeqOutput/

#SEPERATE READS THAT MAP TO THE GYRB PRIMER
for i in $(find . -maxdepth 1 -name '*_R1_001.fastq.gz' | cut -f 2 -d "/" | cut -f 1-2 -d "_"); do
seal.sh in=${i}_L001_R1_001.fastq.gz in2=${i}_L001_R2_001.fastq.gz outu=${i}_16S_L001_R1_001.fastq.gz outu2=${i}_16S_L001_R2_001.fastq.gz out=${i}_gyrB_L001_R1_001.fastq.gz out2=${i}_gyrB_L001_R2_001.fastq.gz literal=AAGGCCACNCCRTGNARDCCDCC,GTCAGGACNCCRTGNARDCCDCC,CCTCTTACNCCRTGNARDCCDCC,TCGTAGACNCCRTGNARDCCDCC copyundefined restrictleft=25 k=14 hdist=1 kpt=t
mv ${i}_16S_L001_R1_001.fastq.gz ${i}_16S_L001_R2_001.fastq.gz ../02AmpliconSorted/16S
mv ${i}_gyrB_L001_R1_001.fastq.gz ${i}_gyrB_L001_R2_001.fastq.gz ../02AmpliconSorted/gyrB
done

module purge