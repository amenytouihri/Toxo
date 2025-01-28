#!/bin/bash
#SBATCH --job-name=get_reference       # Job name
#SBATCH --partition=pibu_el8 # Specify partition
#SBATCH --cpus-per-task=1               # Number of CPU cores
#SBATCH --mem=1000                      # Memory in MB
#SBATCH --time=01:00:00                 # Time limit hrs:min:sec
#SBATCH --output=/data/users/atouihri/rnaseq/log/get_reference_%j.log   # Standard output log
#SBATCH --error=/data/users/atouihri/rnaseq/log/get_reference_%j.err   # Standard error log

# Set URLs and filenames
WORKDIR="/data/users/${USER}/rnaseq_course"         # Working directory
REFGENDIR="$WORKDIR/processed_data/reference_genome"               # Reference genome directory
LOGDIR="$WORKDIR/log"                                # Log directory
REFGENOMEFILE="Mus_musculus.GRCm39.dna.primary_assembly.fa.gz"
ANNOTATIONFILE="Mus_musculus.GRCm39.113.gtf.gz"

#Create the directory for the error and output file 
mkdir -p $LOGDIR

#Create the directory where the reference genome and the annotation will be downloaded
mkdir -p $REFGENDIR

#move to the folder for the reference genome and download the fa and gtf file from ensembl
cd $REFGENDIR
echo "Downloading reference genome and annotation files..."
wget https://ftp.ensembl.org/pub/release-113/fasta/mus_musculus/dna/$REFGENOMEFILE
wget https://ftp.ensembl.org/pub/release-113/gtf/mus_musculus/$ANNOTATIONFILE



#Doing the checksum for the file to check no error  happened during the downloading
echo "Checksum for fasta file"
sum $REFGENDIR/$REFGENOMEFILE
echo "Checksum for gtf file"
sum $REFGENDIR/$ANNOTATIONFILE

#unzip the reference genome 
gunzip $REFGENDIR/$REFGENOMEFILE

#unzip the annotation file 
gunzip $REFGENDIR/$ANNOTATIONFILE

# Compare checksums
echo "Verifying file integrity..."
GENOME_CHECKSUM=$(grep $GENOME_FILE $CHECKSUM_FILE | awk '{print $1}')
ANNOTATION_CHECKSUM=$(grep $ANNOTATION_FILE $CHECKSUM_FILE | awk '{print $1}')

wget ftp://ftp.ensembl.org/pub/release-109/fasta/mus_musculus/dna/CHECKSUMS
wget ftp://ftp.ensembl.org/pub/release-109/gtf/mus_musculus/CHECKSUMS

# Compare the checksums
grep Mus_musculus.GRCm39.dna.primary_assembly.fa.gz CHECKSUMS
grep Mus_musculus.GRCm39.109.gtf.gz CHECKSUMS

if [[ "$GENOME_CHECKSUM" == "$DOWNLOADED_GENOME_CHECKSUM" && "$ANNOTATION_CHECKSUM" == "$DOWNLOADED_ANNOTATION_CHECKSUM" ]]; then
    echo "Checksums match. Files downloaded successfully!"
else
    echo "Error: Checksum mismatch. Please verify the files."
    exit 1
fi

