#!/bin/bash

#SBATCH --job-name=get_sample_textlist
#SBATCH --output=/data/users/atouihri/rnaseq_course/log/download_fastq_%j.out    
#SBATCH --error=/data/users/atouihri/rnaseq_course/log/download_fastq_%j.err    
#SBATCH --time=1:00:00                # Time limit (hh:mm:ss)
#SBATCH --cpus-per-task=1             # Number of CPU cores per task
#SBATCH --mem=1000                    # Memory per node in MB
#SBATCH --partition=pibu_el8         # Partition name

# Variables
WORKDIR="/data/users/${USER}/rnaseq_course"     # Working directory
LOGDIR="$WORKDIR/log"   # Log directory

TARGET_DIR="/data/users/atouihri/samples"  # Destination directory 
OUTDIR="$WORKDIR/samples"  # Output directory


#Create a text file containing the name of the sample the path to the read1 and the path to the read2

for FILE in $OUTDIR/*_*1.fastq.gz
do 

    PREFIX="${FILE%_*.fastq.gz}" # Remove the _R1.fastq.gz from the file name
    SAMPLE=`basename $PREFIX` # Get the sample name
    echo -e "${SAMPLE}\t$FILE\t${FILE%?.fastq.gz}2.fastq.gz"  # Print the sample name and the path to the read1 and read2
done > $OUTDIR/sample_list.txt  