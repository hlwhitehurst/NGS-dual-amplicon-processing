#!/bin/bash
#SBATCH --job-name=housekeep
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --time=06:00:00
#SBATCH --mem=32gb
#SBATCH --output=HouseKeep.%J.out
#SBATCH --error=HouseKeep.%J.err

PAR='/path/to/directory'
cd $PAR


# ZIP ORIGINAL SEQUENCING FILES, REMOVE DIRECTORY
tar -czvf SequencingOutputFASTQ.tar.gz ./01SeqOutput
mv $PAR/01SeqOutput/fastqc-reports $PAR
tar -czvf fastqc-reports.tar.gz ./fastqc-reports
# rm -r $PAR/01SeqOutput

# REMOVE INTERMEDIATE FASTQ.GZ AMPLICON FILES IN 02AmpliconSorted
# rm -r $PAR/02AmpliconSorted/

# REMOVE ALL OTHER INTERMEDIATE FILES FROM 03
for amp in 16S gyrB
do
    rm -r $PAR/03InlineSorted/$amp/01_interleaved
    rm -r $PAR/03InlineSorted/$amp/02_adapter-trimmed
    rm -r $PAR/03InlineSorted/$amp/03_tag1
    rm -r $PAR/03InlineSorted/$amp/04_tag2
    rm -r $PAR/03InlineSorted/$amp/05_interleaved-trimmed
    rm -r $PAR/03InlineSorted/$amp/unindexed
    cd $PAR/03InlineSorted
    tar -czvf InlineIndexed-Trimmed-${amp}.tar.gz ./$amp
done