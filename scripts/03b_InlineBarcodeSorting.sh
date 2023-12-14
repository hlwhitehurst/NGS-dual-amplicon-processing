#!/bin/bash
# We request a compute nodes with 16 CPUs and 32 GB of memory, and at
# most 24 hours of runtime.

#!/bin/bash
#SBATCH --job-name=inline
#SBATCH --nodes=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=32GB
#SBATCH --time=10:00:00

# SET UP
cd /path/to/directory/
REF='/path/to/directory/ref'
PAR='/path/to/directory/'

module purge 
module load bbtools/38.91

#1 TRIM ADAPTERS AND SORT BY INLINE INDEXES

for amp in 16S gyrB
do
    #SET-UP: GO TO RELEVANT DIRECTORY AND MAKE SUBDIRECTORIES
    cd $PAR
    mkdir -p ./03InlineSorted/$amp/01_interleaved
    mkdir -p ./03InlineSorted/$amp/02_adapter-trimmed
    mkdir -p ./03InlineSorted/$amp/03_tag1/unindexed
    mkdir -p ./03InlineSorted/$amp/04_tag2/unindexed
    mkdir -p ./03InlineSorted/$amp/05_interleaved-trimmed
    cd $PAR/02AmpliconSorted/$amp
    
    #GENERATE INTERLEAVED FILES FROM R1 R2 FILES
    for i in $(find . -name '*_R1_001.fastq.gz' | cut -f 2 -d "/"| cut -f 1-3 -d "_" )
    do
    reformat.sh in=${i}_L001_R#_001.fastq.gz out=$PAR/03InlineSorted/$amp/${i}_int_001.fastq.gz 
    done
    
    #TRIM ADAPTERS
    cd $PAR/03InlineSorted/$amp
    for i in $(find . -maxdepth 1 -name '*_int_001.fastq.gz' | cut -f 2 -d "/"| cut -f 1-3 -d "_" )
    do
    bbduk.sh -Xmx1g in=${i}_int_001.fastq.gz out=${i}_int-atrim.fastq.gz ref=$REF/adapters.fa ktrim=r k=23 mink=11 hdist=1 tpe tbo
    mv ${i}_int_001.fastq.gz ./01_interleaved
    done
    
    #SORT BY INLINE INDEX: SORT READS BY F AND R INLINE INDICES
    #A. FORWARD
    for i in $(find . -maxdepth 1 -name '*_int-atrim.fastq.gz' | cut -f 2 -d "/"| cut -f 1-3 -d "_" )
    do
    seal.sh in=${i}_int-atrim.fastq.gz  match=first k=5 restrictleft=7 ref=$REF/FwdInlineTags.fa pattern=${i}_%_ampt1.fastq.gz outu=./unindexed/${i}_T1_unmatched_001.fastq.gz
    mv ${i}_int-atrim.fastq.gz ./02_adapter-trimmed/${i}_int-atrim.fastq.gz 
    done
    #B. REVERSE
    for i in $(find . -maxdepth 1 -name '*_ampt1.fastq.gz' | cut -f 2 -d "/"| cut -f 1-4 -d "_" )
    do
    seal.sh in=${i}_ampt1.fastq.gz match=first k=5 restrictleft=7 ref=$REF/RevInlineTags.fa pattern=${i}_%_inl.fastq.gz outu=./unindexed/${i}_T2_unmatched_001.fastq.gz
    mv ${i}_ampt1.fastq.gz ./03_tag1/${i}_ampt1.fastq.gz
    done
done

#2 TRIM PRIMERS

#A. TRIM 16S PRIMERS
cd $PAR/03InlineSorted/16S
for i in $(find . -maxdepth 1 -name '*_inl.fastq.gz' | cut -f 2 -d "/" | cut -f 1-5 -d "_")
do
bbduk.sh in=${i}_inl.fastq.gz out=${i}_temp.fastq.gz literal=ACGTCATCCCCACCTTCC copyundefined ktrim=l restrictleft=40 k=13 mink=11 hdist=1
bbduk.sh in=${i}_temp.fastq.gz out=${i}_clean.fastq.gz literal=AACMGGATTAGATACCCKG copyundefined ktrim=l restrictleft=40 k=13 mink=11 hdist=1
rm ${i}_temp.fastq.gz
mv ${i}_inl.fastq.gz ./04_tag2
done

#B. TRIM GYRB PRIMERS
cd $PAR/03InlineSorted/gyrB
for i in $(find . -maxdepth 1 -name '*_inl.fastq.gz' | cut -f 2 -d "/" | cut -f 1-5 -d "_")
do
bbduk.sh in=${i}_inl.fastq.gz out=${i}_temp.fastq.gz literal=ACNCCRTGNARDCCDCCNGA copyundefined ktrim=l restrictleft=40 k=13 mink=11 hdist=1
bbduk.sh in=${i}_temp.fastq.gz out=${i}_clean.fastq.gz literal=MGNCCNGSNATGTAYATHGG copyundefined ktrim=l restrictleft=40 k=13 mink=11 hdist=1
rm ${i}_temp.fastq.gz
mv ${i}_inl.fastq.gz ./04_tag2
done

#3. DE-INTERLEAVE
for amp in 16S gyrB
do
    cd $PAR/03InlineSorted/$amp
    for i in $(find . -maxdepth 1 -name '*_clean.fastq.gz' | cut -f 2 -d "/" | cut -f 1-5 -d "_")
    do 
    reformat.sh in=${i}_clean.fastq.gz out1=${i}_R1_clean.fastq.gz out2=${i}_R2_clean.fastq.gz
    mv ${i}_clean.fastq.gz $PAR/03InlineSorted/$amp/05_interleaved-trimmed
    done
done


module purge
