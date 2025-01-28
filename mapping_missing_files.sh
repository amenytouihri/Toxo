#!/usr/bin/env bash
#SBATCH --time=01:00:00
#SBATCH --mem=30000M
#SBATCH --cpus-per-task=5
#SBATCH --job-name=samtools_sort
#SBATCH --output=/data/users/atouihri/rnaseq_course/log/samtools_sort_%J.out
#SBATCH --error=/data/users/atouihri/rnaseq_course/log/samtools_sort_%J.err
#SBATCH --partition=pibu_el8

# Setting the constant for the directories and required files
WORKDIR="/data/users/${USER}/rnaseq_course"                         # Working directory
LOGDIR="$WORKDIR/log"   
OUTDIR="$WORKDIR/mapping"                                           # Output directory

# Create the directory for the error and output file if not present
mkdir -p $LOGDIR

# Specify the BAM file to be processed
FILE="$OUTDIR/SRR7821939.bam"


# Sorting the BAM file
SORTED_BAM="${FILE%.bam}_sorted.bam"
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif samtools sort -m 27000M -@ 5 -o $SORTED_BAM -T temp $FILE

# Index the sorted BAM file
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif samtools index $SORTED_BAM

echo "Sorted and indexed BAM file: $SORTED_BAM"