#!/bin/bash
#SBATCH --job-name=read_counts
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --time=06:00:00
#SBATCH --mem=32gb
#SBATCH --output=FileCount01.%J.out
#SBATCH --error=FileCount01.%J.err

RCD='/path/to/directory/readcounts'
PAR='/path/to/directory'

#MAKE DIRECTORY FOR HOUSING READ COUNT FILES
cd $PAR
mkdir -p ./readcounts
cd $PAR/01SeqOutput

#1. COUNT READS FROM ORIGINAL SEQUENCING FILES
for i in `ls *001.fastq.gz`; do
  #unzip file, count lines, store as variable NUMB
NUMB=$(gunzip -c ${i} | wc -l)
  #divide NUMB variable by 4 (the number of lines per record in fasta format), resulting in number of reads per file.
READS=$(echo "$NUMB/4;" | bc)
  #print out file name and read count into row, appending each record to a file names "readcount"
echo ${i}','$READS >> $RCD/01SeqOutput-counts.csv
done

#2. SET UP LOOP TO COUNT READS FROM PROCESSED FILES
#note: change to amplicon(s) of interest. Here I used 16S and gyrB.
for amp in 16S gyrB
do
  #A. AMPLICON SORTED FASTQ FILES
  cd $PAR/02AmpliconSorted/$amp
  for i in `ls *.fastq.gz` 
  do
  #unzip file, count lines, store as variable NUMB
  NUMB=$(gunzip -c ${i} | wc -l)
  #divide NUMB variable by 4 (the number of lines per record in fasta format), resulting in number of reads per file.
  READS=$(echo "$NUMB/4;" | bc)
  #print out file name and read count into row, appending each record to a file names "readcount"
  echo ${i}','$READS >> $RCD/02_AMPLICON-$amp-counts.csv
  done

  #B. INLINE SORTED FASTQ FILES
  cd $PAR/03InlineSorted/$amp
  for i in `ls *.fastq.gz` 
  do
  #unzip file, count lines, store as variable NUMB
  NUMB=$(gunzip -c ${i} | wc -l)
  #divide NUMB variable by 4 (the number of lines per record in fasta format), resulting in number of reads per file.
  READS=$(echo "$NUMB/4;" | bc)
  #print out file name and read count into row, appending each record to a file names "readcount"
  echo ${i}','$READS >> $RCD/03_INLINE-$amp-counts.csv
  done
done

