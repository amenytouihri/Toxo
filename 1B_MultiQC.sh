#!/bin/bash
#SBATCH --job-name=multiqc_report       # Job name
#SBATCH --partition=pibu_el8            # Specify partition
#SBATCH --cpus-per-task=1               # Number of CPU cores
#SBATCH --mem=2000                      # Memory in MB
#SBATCH --time=01:00:00                 # Time limit hrs:min:sec
#SBATCH --output=/data/users/atouihri/rnaseq_course/log/multiqc_%j.log   # Standard output log
#SBATCH --error=/data/users/atouihri/rnaseq_course/log/multiqc_%j.err   # Standard error log

# Load MultiQC module or activate environment
module load MultiQC/1.11                 # Adjust version if needed

# Set directories
OUTPUT_DIR="../processed_data/multiqc_report" # Directory for MultiQC report
INPUT_DIR="../processed_data"            # Directory with FastQC, Hisat2 logs, etc.

# Create output directory
mkdir -p $OUTPUT_DIR

# Run MultiQC
multiqc $INPUT_DIR -o $OUTPUT_DIR

echo "MultiQC report generated in $OUTPUT_DIR"
