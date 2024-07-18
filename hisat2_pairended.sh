# Define directories
INDEX_DIR="/mnt/TooBigData/rnaseq_pair/grch38"
FASTQ_DIR="/mnt/TooBigData/rnaseq_single"
OUTPUT_DIR="/mnt/TooBigData/rnaseq_single/output_sam"

# Create output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Define the HISAT2 index base name (prefix)
INDEX_PREFIX="${INDEX_DIR}/genome"

# Number of CPU threads to use
THREADS=8

# Quality score encoding (choose --phred33 or --phred64)
PHRED="--phred33"

# RNA strandness (choose appropriate value: FR, RF, etc.)
STRANDNESS="--rna-strandness RF"

# Loop through all FASTQ files in the input directory
for FASTQ_FILE in ${FASTQ_DIR}/*.trimmed.fastq.gz
do
    # Extract the base name of the file (without path and suffix)
    BASE_NAME=$(basename ${FASTQ_FILE} .trimmed.fastq.gz)
    
    # Define the output SAM file name
    OUTPUT_FILE="${OUTPUT_DIR}/${BASE_NAME}.sam"
    
    # Define the summary file name
    SUMMARY_FILE="${OUTPUT_DIR}/${BASE_NAME}_summary.txt"
    
    # Run HISAT2 alignment with additional parameters
    hisat2 -x $INDEX_PREFIX -U $FASTQ_FILE -S $OUTPUT_FILE \
        -p $THREADS $PHRED $STRANDNESS --dta --summary-file $SUMMARY_FILE
    
    echo "Aligned ${FASTQ_FILE} to ${OUTPUT_FILE}"
done
