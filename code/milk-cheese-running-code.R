#3/5 brief work
#redo in a nicer format maybe r markdown for extra practice but make a mess here trying to figure out the code

#3/3 Quality Control: Filtering and Trimming
library('tidyverse')

set.seed(238428)

start_time <- Sys.time()
start_time

pacman::p_load(tidyverse, dada2, phyloseq, patchwork, DT, devtools, install = FALSE)

cheese_raw_fastqs_path <- "data/cheese-fastq-gz"
cheese_raw_fastqs_path

head(list.files(cheese_raw_fastqs_path))

length(list.files(cheese_raw_fastqs_path))

cheese_forward_reads <- list.files(cheese_raw_fastqs_path, pattern = "_1.fastq.gz", full.names = TRUE)  
head(cheese_forward_reads)
stopifnot(length(cheese_forward_reads) < length(list.files(cheese_raw_fastqs_path)))
cheese_reverse_reads <- list.files(cheese_raw_fastqs_path, pattern = "_1.fastq.gz", full.names = TRUE)
head(cheese_reverse_reads)
stopifnot(length(cheese_reverse_reads) == length(cheese_forward_reads))

cheese_random_samples <- sample(1:length(cheese_reverse_reads), size = 12)
cheese_random_samples

cheese_forward_filteredQual_plot_12 <- plotQualityProfile(cheese_forward_reads[cheese_random_samples]) + 
  labs(title = "Forward Read: Raw Quality")

cheese_reverse_filteredQual_plot_12 <- plotQualityProfile(cheese_reverse_reads[cheese_random_samples]) + 
  labs(title = "Reverse Read: Raw Quality")

cheese_forward_filteredQual_plot_12 + cheese_reverse_filteredQual_plot_12

cheese_forward_preQC_plot <- 
  plotQualityProfile(cheese_forward_reads, aggregate = TRUE) + 
  labs(title = "Forward Pre-QC")

cheese_reverse_preQC_plot <- 
  plotQualityProfile(cheese_reverse_reads, aggregate = TRUE) + 
  labs(title = "Reverse Pre-QC")

cheese_preQC_aggregate_plot <- 
  cheese_forward_preQC_plot + cheese_reverse_preQC_plot

cheese_preQC_aggregate_plot

#1 of Pre-QC: my first thought is at least the graphs are the same, so maybe there was sequencing limitations or problems. there are two concerning dips before 150 bp which makes me unsure if i should trim the sequence there or go all the way to 150

cheese_sample_names <- sapply(strsplit(basename(cheese_forward_reads), "_"), `[`,1) 
head(cheese_sample_names)

cheese_filtered_fastqs_path <- "data/01_DADA2/02_filtered_fastqs"
cheese_filtered_fastqs_path

cheese_filtered_forward_reads <- 
  file.path(cheese_filtered_fastqs_path, paste0(cheese_sample_names, "_R1_filtered.fastq.gz"))
length(cheese_filtered_forward_reads)

cheese_filtered_reverse_reads <- 
  file.path(cheese_filtered_fastqs_path, paste0(cheese_sample_names, "_R2_filtered.fastq.gz"))
head(cheese_filtered_reverse_reads)

#filter and trim -- 

