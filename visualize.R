# scripts/visualize.R
library(ggplot2)
library(gridExtra)

# VERİYİ OKU
if (file.exists("results/read_stats.csv")) {
  df <- read.csv("results/read_stats.csv")
} else {
  stop("HATA: results/read_stats.csv bulunamadi! Lutfen once analyze_reads adiminin bittiginden emin olun.")
}

# GRAFİKLERİ OLUŞTUR
p1 <- ggplot(df, aes(x=length)) +
  geom_density(fill="steelblue", alpha=0.7) +
  geom_vline(xintercept=median(df$length), color="red", linetype="dashed") +
  labs(title="Read Length Distribution", x="Length (bp)", y="Density") +
  theme_minimal()

p2 <- ggplot(df, aes(x="", y=mean_quality)) +
  geom_boxplot(fill="coral", alpha=0.7) +
  labs(title="Quality Score Distribution", x="", y="Mean Quality Score") +
  theme_minimal()

p3 <- ggplot(df, aes(x="", y=gc_content)) +
  geom_violin(fill="seagreen", alpha=0.7) +
  labs(title="GC Content Distribution", x="", y="GC Content (%)") +
  theme_minimal()

# KAYDET
combined <- grid.arrange(p1, p2, p3, ncol=3)
ggsave("results/qc_plots_R.png", combined, width=15, height=5, dpi=150)

cat("\n[BASARILI] R grafigi 'results/qc_plots_R.png' olarak kaydedildi!\n")
