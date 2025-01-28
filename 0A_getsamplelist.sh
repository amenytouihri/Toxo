#!/bin/bash

#SBATCH --job-name=get_sample_list
#SBATCH --output=/data/users/atouihri/rnaseq_course/log/download_fastq_%j.out    
#SBATCH --error=/data/users/atouihri/rnaseq_course/log/download_fastq_%j.err    
#SBATCH --time=1:00:00                # Time limit (hh:mm:ss)
#SBATCH --cpus-per-task=1             # Number of CPU cores per task
#SBATCH --mem=1000                    # Memory per node in MB
#SBATCH --partition=pibu_el8         # Partition name

# Variables
WORKDIR="/data/users/${USER}/rnaseq_course"     # Working directory
LOGDIR="data/users/atouihri/rnaseq_course/log"   # Log directory
READSDIR="/data/courses/rnaseq_course/toxoplasma_de/reads" # Reads directory
TARGET_DIR="/data/users/atouihri/rnaseq_course/samples"  # Destination directory 
OUTDIR="$WORKDIR/samples/toxoplasma_de/reads"  # Output directory


# Copy files to the destination directory
echo "Copying files from $READSDIR to $TARGET_DIR..."
# Copy the files
cp "$READSDIR"/*.fastq.gz "$TARGET_DIR"
# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "Files copied successfully!"
else
    echo "Error occurred during copy."
    exit 1
fi

