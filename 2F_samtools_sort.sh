#!/usr/bin/env bash
#SBATCH --time=01:00:00
#SBATCH --mem=30000M
#SBATCH --cpus-per-task=5
#SBATCH --job-name=samtools_sort
#SBATCH --output=/data/users/atouihri/rnaseq_course/log/samtools_sort_%J.out
#SBATCH --error=/data/users/atouihri/rnaseq_course/log/samtools_sort_%J.err
#SBATCH --partition=pibu_el8
#SBATCH --array=1-16

#Setting the constant for the directories and required files
WORKDIR="/data/users/${USER}/rnaseq_course"                         # Working directory
LOGDIR="$WORKDIR/log"   
SAMPLELIST="$WORKDIR/samples/sample_list.txt" # Sample list
OUTDIR=$WORKDIR/mapping                                         # Output directory




#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

#take the sample name, path to the read1 and read2 line by line 
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`   # Get the sample name
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST` # Get the path to read1
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST` # Get the path to read2


# Run samtools sort within the Apptainer container to sort the BAM file
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif samtools sort -m 27000M -@ 5 -o $OUTDIR/${SAMPLE}sorted.bam -T temp $OUTDIR/$SAMPLE.bam