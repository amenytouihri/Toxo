#!/usr/bin/env bash
#SBATCH --time=02:00:00          # Time limit hrs:min:sec
#SBATCH --mem=8G                 # Memory in MB
#SBATCH --cpus-per-task=8       # Number of CPU cores
#SBATCH --job-name=hisat_mapping  # Job name
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/atouihri/rnaseq_course/log/hisat_mapping_%J.out # Standard output log
#SBATCH --error=/data/users/atouihri/rnaseq_course/log/hisat_mapping_%J.err  # Standard error log
#SBATCH --array=1-16

#Setting the constant for the directories and required files
WORKDIR="/data/users/${USER}/rnaseq_course"                         # Working directory
REFGENDIR="$WORKDIR/processed_data/reference_genome"               # Reference genome directory
LOGDIR="$WORKDIR/log"                               # Log directory
SAMPLELIST="$WORKDIR/samples/sample_list.txt"
INDEXDIR="$WORKDIR/index_hisat"                               # Index directory
OUTDIR=$WORKDIR/mapping                                         # Output directory


#Create the directory for the error and output file if not present
mkdir -p $OUTDIR

#take the sample name, path to the read1 and read2 line by line 
SAMPLE=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $1; exit}' $SAMPLELIST`    # Get the sample name
READ1=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $2; exit}' $SAMPLELIST`     # Get the path to read1
READ2=`awk -v line=$SLURM_ARRAY_TASK_ID 'NR==line{print $3; exit}' $SAMPLELIST`     # Get the path to read2

#Mapping the reads by using hisat2 and saving the output in sam format
apptainer exec --bind /data /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif \

hisat2 -x $INDEXDIR/genome_index -1 $READ1 -2 $READ2 -S $OUTDIR/$SAMPLE.sam --threads 8 --rna-strandness RF --summary-file $OUTDIR/${SAMPLE}mapping_summary.txt
