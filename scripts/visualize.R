# scripts/visualize.R
library(ggplot2)
library(gridExtra)

# Komut satiri argumanlarini al
args <- commandArgs(trailingOnly = TRUE)
input_file <- args[1]
output_file <- args[2]

# Sample adini cikti dosyasindan cikar
SAMPLE <- gsub("_qc_plots_R.png", "", basename(output_file))

# VERIYI OKU
if (file.exists(input_file)) {
  df <- read.csv(input_file)
} else {
  stop(paste("ERROR:", input_file, "not found!"))
}

# N50 hesapla
sorted_lengths <- sort(df$length, decreasing = TRUE)
total_bases <- sum(sorted_lengths)
cumsum <- 0
n50 <- 0
for (l in sorted_lengths) {
  cumsum <- cumsum + l
  if (cumsum >= total_bases / 2) {
    n50 <- l
    break
  }
}

# Ozet istatistikleri yazdir
cat("\n=== SUMMARY STATISTICS (R) ===\n")
cat(paste("GC Content   - Mean:", round(mean(df$gc_content), 2), "| Median:", round(median(df$gc_content), 2), "\n"))
cat(paste("Read Length  - Mean:", round(mean(df$length), 2), "| Median:", round(median(df$length), 2), "| N50:", n50, "\n"))
cat(paste("Quality Score- Mean:", round(mean(df$mean_quality), 2), "| Median:", round(median(df$mean_quality), 2), "\n"))

# GRAFIKLERI OLUSTUR
p1 <- ggplot(df, aes(x=length)) +
  geom_density(fill="steelblue", alpha=0.7) +
  geom_vline(xintercept=median(df$length), color="red", linetype="dashed", size=1) +
  geom_vline(xintercept=n50, color="orange", linetype="dashed", size=1) +
  labs(title=paste0(SAMPLE, " - Read Length Density"),
       x="Length (bp)", y="Density") +
  theme_minimal() +
  annotate("text", x=Inf, y=Inf, 
           label=paste0("Mean: ", round(mean(df$length), 1), 
                        "\nMedian: ", round(median(df$length), 1),
                        "\nN50: ", n50,
                        "\nTotal: ", nrow(df)),
           hjust=1.1, vjust=1.1, size=3, color="black")

p2 <- ggplot(df, aes(x="", y=mean_quality)) +
  geom_boxplot(fill="coral", alpha=0.7) +
  geom_hline(yintercept=10, color="darkred", linetype="dotted", size=1) +
  labs(title=paste0(SAMPLE, " - Quality Score Distribution"),
       x="", y="Mean Quality Score") +
  theme_minimal() +
  annotate("text", x=Inf, y=Inf, 
           label=paste0("Mean: ", round(mean(df$mean_quality), 1),
                        "\nMedian: ", round(median(df$mean_quality), 1)),
           hjust=1.1, vjust=1.1, size=3, color="black")

p3 <- ggplot(df, aes(x="", y=gc_content)) +
  geom_violin(fill="seagreen", alpha=0.7) +
  geom_hline(yintercept=52, color="purple", linetype="dashed", size=1) +
  labs(title=paste0(SAMPLE, " - GC Content Distribution"),
       x="", y="GC Content (%)") +
  theme_minimal() +
  annotate("text", x=Inf, y=Inf, 
           label=paste0("Mean: ", round(mean(df$gc_content), 1), "%",
                        "\nMedian: ", round(median(df$gc_content), 1), "%"),
           hjust=1.1, vjust=1.1, size=3, color="black")

# KAYDET
combined <- grid.arrange(p1, p2, p3, ncol=3)
ggsave(output_file, combined, width=15, height=6, dpi=150)

cat(paste("\n[SUCCESS] R plot saved as '", output_file, "'\n"))