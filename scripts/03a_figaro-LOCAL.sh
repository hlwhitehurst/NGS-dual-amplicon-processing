# I ran the following command locally because I had the requisite software installed. You will need :
# figaro : https://github.com/Zymo-Research/figaro (I used version 1.1.2)
# seqtk kit : https://github.com/lh3/seqtk.git (I used version Seqtk-1.3 (r106))
# Note that figaro input requires the amplicon length EXCLUDING primers. however, I use the amplicon + primer length for gyrb because figaro is known to crash with smaller fragments:
# https://github.com/Zymo-Research/figaro/issues/36


for amp in 16S gyrB
do
    cd /path/to/directory/Isolates_HW1/$amp
    gzip -d *.gz
    echo "...acquiring fastq statistics"
    seqkit stat *.fastq > ../stats/$amp-fastq-stats.txt
    echo "...fastq statistics complete. Top 10 rows:"
    head -n 10 ../stats/$amp-fastq-stats.txt
    awk '{if (NR==1)  print "please remove the following files or reads of unequal length: " }{ if ($6<301 || $7>301 ) print $0 }' ../stats/$amp-fastq-stats.txt > ../stats/$amp-removed-fastq.txt
    echo "...removing fastq files which have no reads:"
    cat  ../stats/$amp-removed-fastq.txt
    awk '{if (NR>2) print $1}' ../stats/$amp-removed-fastq.txt | xargs rm 
    cd /path/to/software/figaro
    echo "...beginning figaro analysis"
    if [[ "$amp" == "16S" ]]
    then
        python3.7 figaro.py -i /path/to/SeqRuns/Isolates_HW1/16S -o /path/to/SeqRuns/Isolates_HW1/stats/16S-figaro -a 403 -f 19 -r 20 > 16S-figaro.txt
    else
        python3.7 figaro.py -i /path/to/SeqRuns/Isolates_HW1/gyrB -o /path/to/SeqRuns/Isolates_HW1/stats/gyrB-figaro -a 289 -f 20 -r 20 > gyrB-figaro.txt
    fi
    echo "figaro analysis closing. Done."
done

