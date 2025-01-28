#!/bin/bash

# preprocess.sh: Script for preprocessing raw FASTQ files 
# using FastQC

#SBATCH --job-name=preprocess_fastq   
#SBATCH --output=/data/users/atouihri/rnaseq_course/log/fastqc_%j.log   # Standard output log
#SBATCH --error=/data/users/atouihri/rnaseq_course/log/fastqc_%j.err   # Standard error log 
#SBATCH --time=2:00:00                # Time limit (hh:mm:ss)
#SBATCH --cpus-per-task=1             # Number of CPU cores per task
#SBATCH --mem=1000                    # Memory per node in MB
#SBATCH --partition=pibu_el8         # Partition name

# Load necessary modules or activate environments
module load FastQC/0.11.9-Java-11

# Create output directory
mkdir -p ../processed_data/quality_control/

# Check if the module loaded successfully
if [ $? -ne 0 ]; then
    # If the module failed to load, exit the script
    echo "Error: FastQC module not found."
    exit 1
fi

# Verify the existence of FASTQ files
if ls /data/users/atouihri/rnaseq_course/samples/*.fastq.gz 1> /dev/null 2>&1; then
    echo "FASTQ files found."
else
    echo "Error: FASTQ files not found."
    exit 1
fi
#runs FastQC on each file using 2 threads and outputs the results to the quality_control/.

for sample in /data/users/atouihri/rnaseq_course/samples/*.fastq.gz; do
    fastqc -t 2 "$sample" -o  ../processed_data/quality_control/
    # Check if FastQC analysis was successful
    if [ $? -ne 0 ]; then
        echo "Error occurred during FastQC analysis for $sample."
        exit 1
    fi
done

echo "FastQC analysis completed successfully."