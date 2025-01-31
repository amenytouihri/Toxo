####Data
#Load and clean data
```{r, echo=FALSE,message=FALSE,warning=FALSE}
#load data, row.names: sets the first col as row names 
data_count <- read.delim("gene_count_summary.txt", header = T, row.names = 1)

#clean column names to just have the sample names
colnames(data_count) <- gsub(".*mapping\\.|sorted.bam.*", "", colnames(data_count))

#remove chr, start, end, strand, and length columns
data_count <- data_count[ -c(1:5) ]

#load group data
data_col <- read.csv(“samples_list.csv", header = T, row.names = 1)
data_col$Tissue <- as.factor(data_col$Tissue)
data_col$Treatment <- as.factor(data_col$Treatment) #sets groups as categorical variables

# Check that row names in the sample data match the column names in the count matrix 
all(rownames(data_col) == colnames(data_count))

#### Create DESeq dataset
# Load the same group data again to ensure it's in the correct format for DESeq2 analysis
data_col <- read.csv("Groups.csv", header = T, row.names = 1)
data_col$Group <- as.factor(data_col$Group)  # Categorize the groups as factors

# Double-check if the rows of sample information and columns of count data match
all(rownames(data_col) == colnames(data_count))

# Create a DESeqDataSet object from the count matrix and sample metadata
dds <- DESeqDataSetFromMatrix(countData = data_count,
                              colData = data_col,
                              design = ~ Group)

# Run DESeq2 to process the data and perform differential expression analysis
result_DEseq <- DESeq(dds)

# Apply variance stabilizing transformation to the count data to normalize for gene expression 
result_DEseq_vst <- vst(result_DEseq, blind = TRUE)

#### PCA plot
# Create a PCA plot using the variance-stabilized counts and color by group
plotPCA(result_DEseq_vst, intgroup = "Group") +
  theme_bw() +  # Apply a clean theme
  scale_color_manual(name = "Groups",
                     labels = c("Blood WT Infected", "Blood WT Uninfected", "Lung WT Infected", "Lung WT Uninfected"), 
                     values = c("#DE2820", "#E57259", "#2062DE", "#7CA2E9"))
                      
#### Pairwise comparisons #Lung case vs control
# Define pairwise comparison (Lung case vs control)
comparaison_name = "Lung case v control"
                      
# Perform DESeq2 differential expression analysis
dds <- DESeq(dds)
                     
# Generate MA plot for the comparison
df_lung_case_control <- run_pairwise_analysis(c("Group", "Lung_WT_Case", "Lung_WT_Control"), comparaison_name, padj_threshold=0.05)
                      
# Export results to an Excel file
tmp_file <- "/Users/ameny/Documents/UniFr/RNA sequencing/DE_lung_forgsea.xlsx"
df <- df_lung_case_control %>%
tibble::rownames_to_column(var = "Gene_ID")
export(df, tmp_file)
                      
#### Differential expression analysis
# Create volcano plot
volcano_plot <- ggplot(df_lung_case_control, aes(x = log2FoldChange, y = -log10(padj))) +
                        geom_point(aes(color = padj < 0.05), size = 2, alpha = 0.7) +  # Color points based on significance (padj < 0.05)
                        scale_color_manual(values = c("grey", "teal")) +  # Grey for non-significant, teal for significant points
                        geom_vline(xintercept = c(-2, 2), col = "black", linetype = "dashed") +  # Add dashed lines at logFC = -2 and 2
                        geom_hline(yintercept = -log10(0.05), col = "black", linetype = "dashed") +  # Add dashed line at P-value = 0.05
                        labs(title = "Volcano Plot for Lung_WT_Control ung_WT_Case", x = "Log2 Fold Change", y = "-Log10 Adjusted P-value)") +
                        theme_minimal() +
                        theme(legend.position = "none")  # Hide legend for color aesthetic
                      
# Show the volcano plot
print(volcano_plot)
                      
                      
 #### Boxplots of individual genes
# Apply variance stabilizing transformation to the data for better visualization
result_DEseq_vst <- vst(result_DEseq, blind = TRUE)
# Convert transformed data to a dataframe and add gene names as a column
expr_data <- as.data.frame(assay(result_DEseq_vst))  
expr_data$Gene <- rownames(expr_data)  
                      
# Add sample names as a column
datacol2 <- data_col
datacol2$Sample <- rownames(data_col)
                      
# Reshape the expression data for plotting
expr_long <- melt(expr_data, id.vars = "Gene", variable.name = "Sample", value.name = "Expression")
                      
# Merge the reshaped data with sample metadata
expr_long <- merge(expr_long, datacol2) 
                      
# Filter the data for lung samples only
expr_long <- subset(expr_long, Group %in% c("Lung_WT_Case", "Lung_WT_Control"))
                      
# Generate boxplots for individual genes of interest
p1 <- gene_boxplotter("ENSMUSG00000078853", plot_title = "Igtp") + plot_themes
p2 <- gene_boxplotter("ENSMUSG00000034855", plot_title = "Cxcl10") + plot_themes
p3 <- gene_boxplotter("ENSMUSG00000003379", plot_title = "Cd79a") + plot_themes +
theme(legend.position = "right")
                      
# Arrange the boxplots in a grid
ggarrange(p1, p2, p3, ncol = 3, nrow = 1)
                      
##Overrepresentation analysis
# Perform Gene Ontology (GO) analysis for Molecular Function (MF)
 MF_all <- run_go_analysis_pairwise(df_lung_case_control,comparaison_name,ont="MF",regulation = "all")
                      
# Generate a plot to visualize the overrepresentation of MF terms
p2 <- MF_all + plot_themes
                      
# Display the plot
ggarrange(p2, ncol = 1, nrow = 1)

#### Gene set enrichment analysis
# Perform Gene Ontology Enrichment Analysis for Molecular Function (MF)
ego_mf <- gseGO(geneList = geneList,OrgDb = org.Mm.eg.db,
                ont = "MF",  # Set to Molecular Function
                keyType = "ENSEMBL",
                minGSSize = 50,
                maxGSSize = 300,
                pvalueCutoff = 0.05,
                verbose = FALSE)
                      
# Create the dot plot for Molecular Function (MF)
 gset_MF <- dotplot(ego_mf, showCategory = 10,  # Number of GO terms to show
title = "Molecular Function") + 
scale_fill_gradient(low = "blue", high = "red") +  # Red to blue color gradient for p-value significance
theme_minimal() +  # Minimal theme for clean visualization
theme(axis.text.x = element_text(angle = 90, hjust = 1))  # Rotate x-axis labels for better readability
                      
# Show the plot
ggarrange(gset_MF, ncol = 1, nrow = 1)
                      
