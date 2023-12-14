# NGS-dual-amplicon-processing
Processing of dual amplicon (16S and gyrB) amplicon libraries with inline barcoding.

## Table of Contents
+ [Overview](https://github.com/hlwhitehurst/NGS-dual-amplicon-processing/blob/main/README.md#overview)

## Overview
This pipleine computationally sorts amplicon Illumina libraries that contain inline barcodes. Each library consists of dual amplification of 16s and gyrB amplification for a given leaf microbiome sample. To increase multiplex capacity, I incorporated inline barcodes that were read as the first bases of sequencing. The construct details are available by request **provide citation once manuscript is published**. In brief, the constructs look like the following:

5' N7 barcoded adapter--F inline barcode--F primer--amplicon--R primer--R inline barcode -- i5 barcoded adapter 3'

## Dependencies 
+ [FastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) v 0.11.9
+ [MultiQC](https://multiqc.info/) v 1.9
+ [Figaro](https://github.com/Zymo-Research/figaro) v 1.1.2
+ [BBTools Suite](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/) v 38.91
+ [seqtk](https://github.com/lh3/seqtk.git) v 1.3 (r106)

## Directory Structure
The starting directory structure requires the fastQ files be in the 01_SeqOutput directory. FastQ files are available in NCBI under the project **share project ID once published** Reference files and scripts are stored in their respective directories, and are available in this github repository. 

The scripts build the directories as you progress in through the pipelines. See the script section below for details.

### Starting Directory Structure
```
├── 01_SeqOutput ** Note: this is where all FastQ files should start
├── ref
│   ├── adapters.fa
│   ├── FwdInlineTags.fa
│   ├── RevInlineTags.fa
├── scripts
│   ├── 01a_FastQC.sh
│   ├── 01b_MultiQC.sh
│   ├── 02_AmpliconMatch.sh
│   ├── 03a_figaro-LOCAL.sh
│   ├── 03b_InlineBarcodeSorting.sh
│   ├── 04a_ReadCounts.sh
│   └── 04b_HouseKeeping.sh
```
### Final Directory Structure
```
├── 01_SeqOutput 
├── 02_AmpliconSorted 
│   ├── 16S
│   ├── gyrB
├── 03_InlineSorted
│   ├── 16S 
│   ├── gyrB
├── fastqc-reports
├── figaro
├── readcounts
├── ref
│   ├── adapters.fa
│   ├── FwdInlineTags.fa
│   ├── RevInlineTags.fa
├── scripts
│   ├── 01a_FastQC.sh
│   ├── 01b_MultiQC.sh
│   ├── 02_AmpliconMatch.sh
│   ├── 03a_figaro-LOCAL.sh
│   ├── 03b_InlineBarcodeSorting.sh
│   ├── 04a_ReadCounts.sh
│   └── 04b_HouseKeeping.sh
```

## Pipeline

The scripts are numbered both as the order they are used and also according to the directories to which they output. For example, the 01a_FastQC and 01b_MultiQC refer to the fastQ files in the 01_SeqOutput Directory. 02_AmpliconMatch.sh outputs to the 02_AmpliconSorted directory, etc.

All scripts were run on the NYU Greene HPC, except for the Figaro script which was run on my local computer. 

| Script Name | Description| 
| -------------| ------------| 
| 1) 01a_FastQC.sh | Generate FastQC files for all Illumina FastQ files contained in directory "01_SeqOutput" |
| 2) 01b_MultiQC.sh | Summarize all FastQC Files in a MultiQC file |
| 3) 02_AmpliconMatch.sh | Sort all amplicons that match gyrB primers into gyrB directory, while non-matching sort to 16S directory | 
| 4) 03a_figaro-LOCAL.sh | Optimize trimming parameters for subsequent dada2 analysis. Note: I ran this on my local computer.|
| 5) 03b_InlineBarcodeSorting.sh | Trim off Illumina adapters. Sort reads based on inline barcodes, then trim off inline barcodes and primers|
| 6) 04a_ReadCounts.sh | Perform read counts on all files to track how many reads were removed/carried through each step. This is particularly useful to catch any steps that are disporoportionally causing the loss of reads. |
| 7) 04b_HouseKeeping.sh | Should be done after reviewing the read counts. Removes all intermediate files, then zips and archives directories. | 

