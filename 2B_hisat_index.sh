#!/usr/bin/env bash
#SBATCH --time=03:00:00          # Time limit hrs:min:sec
#SBATCH --mem=8G                 # Memory in MB
#SBATCH --cpus-per-task=1        # Number of CPU cores
#SBATCH --job-name=hisat_index   # Job name
#SBATCH --partition=pibu_el8
#SBATCH --output=/data/users/atouihri/rnaseq_course/log/hisat_index_%J.out # Standard output log
#SBATCH --error=/data/users/atouihri/rnaseq_course/log/hisat_index_%J.err  # Standard error log



#Setting the constant for the directories and required files
WORKDIR="/data/users/${USER}/rnaseq_course"                          # Working directory
REFGENDIR="$WORKDIR/processed_data/reference_genome"                 # Reference genome directory
LOGDIR="$WORKDIR/log"                                                  # Log directory
INDEXDIR="$WORKDIR/index_hisat"                                       # Index directory
REFGENOMEFILE="Mus_musculus.GRCm39.dna.primary_assembly.fa"          # Reference genome file


#Create the directory for the error and output file 
mkdir -p $LOGDIR

#Create the output directory
mkdir -p $INDEXDIR

#Use hisat to create the index the parameter $REFGENDIR/$REFGENOMEFILE correspond to the genome file and $INDEXDIR/genome_index to the path and name of the resulting index file
apptainer exec --bind $WORKDIR /containers/apptainer/hisat2_samtools_408dfd02f175cd88.sif hisat2-build $REFGENDIR/$REFGENOMEFILE $INDEXDIR/genome_index