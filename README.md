# NGS-dual-amplicon-processing
Processing of dual amplicon (16S and gyrB) amplicon libraries with inline barcoding.

## Overview
This pipleine computationally sorts amplicon Illumina libraries that contain inline barcodes. Each library consists of 16s and gyrB amplification of leaf communities. To increase multiplex capacity, I incorporated inline barcodes that were read as the first bases of sequencing. The construct details are available by request *(will provide citation once manuscript is published). In brief, the constructs look like the following:

5' N7 barcoded adapter--F inline barcode--F primer--amplicon--R primer--R inline barcode -- i5 barcoded adapter 3'

## Dependencies
[FastQC] v 0.11.9
[Figaro](https://github.com/Zymo-Research/figaro) v 1.1.2
[BBTools Suite](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/)
[seqtk](https://github.com/lh3/seqtk.git) v 1.3 (r106)

## Final Directory Structure

## Pipeline
-------------------
| 1) 01a_FastQC.sh | Generate FastQC files for all Illumina FastQ files contained in directory "01_SeqOutput" |
| 2) 01b_MultiQC.sh | Summarize all FastQC Files in a MultiQC file |
| 3) 02_AmpliconMatch.sh | Sort all amplicons that match gyrB primers into gyrB directory, while non-matching sort to 16S directory | 
| 4) 03a_figaro-LOCAL.sh | Optimize trimming parameters for subsequent dada2 analysis. Note: I ran this on my local computer.|
| 5) 03b_InlineBarcodeSorting.sh | Trim off Illumina adapters. Sort reads based on inline barcodes, then trim off inline barcodes and primers|
| 6) 04a_ReadCounts.sh | Perform read counts on all files to track how many reads were removed/carried through each step. This is particularly useful to catch any steps that are disporoportionally causing the loss of reads. |
| 7) 04b_HouseKeeping.sh | Should be done after reviewing the read counts. Removes all intermediate files, then zips and archives directories. | 
-------------------
