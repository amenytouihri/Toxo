#!/usr/bin/env bash
#SBATCH --time=01:00:00
#SBATCH --mem=4G
#SBATCH --cpus-per-task=1
#SBATCH --job-name=samtools_conversion_bam
#SBATCH --output=/data/users/atouihri/rnaseq_course/log/samtools_conversion_bam_%J.out
#SBATCH --error=/data/users/atouihri/rnaseq_course/log/samtools_conversion_bam_%J.err
#SBATCH --partition=pibu_el8
#SBATCH --array=1-16

#Setting the constant for the directories and required files
WORKDIR="/data/users/${USER}/rnaseq_course"                         # Working directory
LOGDIR="$WORKDIR/log"                                      # Log directory
SAMPLELIST="$WORKDIR/samples/sample_list.txt"  # Sample list
OUTDIR=$WORKDIR/mapping                                         # Output directory



#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

#take the sample name, path to the read1 and read2 line by line 
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`    # Get the sample name 
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`     # Get the path to read1
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`     # Get the path to read2

#indexing the bam file
#loading the required  modules to run the samtools to index the bam file
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif samtools index $OUTDIR/${SAMPLE}sorted.bam