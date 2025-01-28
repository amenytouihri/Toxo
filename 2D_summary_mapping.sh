#!/usr/bin/env bash
#SBATCH --time=00:10:00
#SBATCH --mem=100M
#SBATCH --cpus-per-task=1
#SBATCH --job-name=mapping_summaries
#SBATCH --output=/data/users/atouihri/rnaseq_course/log/summary_mapping_%J.out # Standard output log
#SBATCH --error=/data/users/atouihri/rnaseq_course/log/summary_mapping_%J.err  # Standard error log
#SBATCH --partition=pibu_el8


#Setting the constant for the directories and required files
WORKDIR="/data/users/${USER}/rnaseq_course"                         # Working directory
MAPPINGDIR="$WORKDIR/mapping"                                   # Mapping directory
LOGDIR="$WORKDIR/log"                           # Log directory
OUTFILE="$MAPPINGDIR/all_summary_mapping.txt"                 # Output file


#Create the directory for the error and output file if not present
mkdir -p $LOGDIR

# Create the output file
echo "Alignement rate summary for all sample" > $OUTFILE
    # Loop through each mapping summary file in the mapping directory
for FILE in $(ls $MAPPINGDIR/*mapping_summary.txt);
do
    # Extract the sample name from the file name
    SAMPLE=$(basename "$FILE" | sed 's/mapping_summary.txt//')
    echo "####################################################################################################################################################################" >> $OUTFILE
    echo $SAMPLE >> $OUTFILE    # Append the sample name to the output file
    cat $FILE >> $OUTFILE   # Append the content of the mapping summary file to the output file
    echo "####################################################################################################################################################################" >> $OUTFILE
done