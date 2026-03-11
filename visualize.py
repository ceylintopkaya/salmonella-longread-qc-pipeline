# -*- coding: utf-8 -*-
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv("results/read_stats.csv")

sorted_lengths = sorted(df['length'], reverse=True)
total_bases = sum(sorted_lengths)
cumsum = 0
n50 = 0
for l in sorted_lengths:
    cumsum += l
    if cumsum >= total_bases / 2:
        n50 = l
        break

print("=== SUMMARY STATISTICS ===")
print("GC Content   - Mean:", round(df['gc_content'].mean(),2), "| Median:", round(df['gc_content'].median(),2))
print("Read Length  - Mean:", round(df['length'].mean(),2), "| Median:", round(df['length'].median(),2), "| N50:", n50)
print("Quality Score- Mean:", round(df['mean_quality'].mean(),2), "| Median:", round(df['mean_quality'].median(),2))

sns.set_theme(style="whitegrid")
fig, axes = plt.subplots(2, 2, figsize=(16, 11))
fig.suptitle("Salmonella sp. - Long-read QC Report (Python)", fontsize=15, fontweight='bold')

axes[0,0].hist(df['length'], bins=50, color='steelblue', edgecolor='black')
axes[0,0].axvline(df['length'].median(), color='red', linestyle='dashed', linewidth=1.5, label='Median')
axes[0,0].axvline(n50, color='orange', linestyle='dashed', linewidth=1.5, label='N50')
axes[0,0].set_title('Read Length Distribution')
axes[0,0].set_xlabel('Length (bp)')
axes[0,0].set_ylabel('Read Count')
axes[0,0].legend()
stats_text = "Mean: " + str(round(df['length'].mean(),1)) + "\nMedian: " + str(round(df['length'].median(),1)) + "\nN50: " + str(n50) + "\nTotal: " + str(len(df))
axes[0,0].text(0.97, 0.97, stats_text, transform=axes[0,0].transAxes, fontsize=8, verticalalignment='top', horizontalalignment='right', bbox=dict(boxstyle='round', facecolor='white', alpha=0.8))

axes[0,1].hist(df['mean_quality'], bins=50, color='coral', edgecolor='black')
axes[0,1].axvline(df['mean_quality'].median(), color='red', linestyle='dashed', linewidth=1.5, label='Median')
axes[0,1].axvline(10, color='darkred', linestyle='dotted', linewidth=2, label='Q10 Threshold')
axes[0,1].set_title('Mean Quality Score Distribution')
axes[0,1].set_xlabel('Mean Quality Score')
axes[0,1].set_ylabel('Read Count')
axes[0,1].legend()
stats_text = "Mean: " + str(round(df['mean_quality'].mean(),1)) + "\nMedian: " + str(round(df['mean_quality'].median(),1)) + "\nTotal: " + str(len(df))
axes[0,1].text(0.03, 0.97, stats_text, transform=axes[0,1].transAxes, fontsize=8, verticalalignment='top', horizontalalignment='left', bbox=dict(boxstyle='round', facecolor='white', alpha=0.8))

axes[1,0].hist(df['gc_content'], bins=50, color='seagreen', edgecolor='black')
axes[1,0].axvline(df['gc_content'].median(), color='red', linestyle='dashed', linewidth=1.5, label='Median')
axes[1,0].axvline(52, color='purple', linestyle='dashed', linewidth=1.5, label='Expected GC (52%)')
axes[1,0].set_title('GC Content Distribution')
axes[1,0].set_xlabel('GC Content (%)')
axes[1,0].set_ylabel('Read Count')
axes[1,0].legend()
stats_text = "Mean: " + str(round(df['gc_content'].mean(),1)) + "%\nMedian: " + str(round(df['gc_content'].median(),1)) + "%\nTotal: " + str(len(df))
axes[1,0].text(0.03, 0.97, stats_text, transform=axes[1,0].transAxes, fontsize=8, verticalalignment='top', horizontalalignment='left', bbox=dict(boxstyle='round', facecolor='white', alpha=0.8))

axes[1,1].scatter(df['length'], df['mean_quality'], alpha=0.3, color='purple', s=5)
axes[1,1].axhline(10, color='darkred', linestyle='dotted', linewidth=2, label='Q10 Threshold')
axes[1,1].set_title('Read Length vs Quality Score')
axes[1,1].set_xlabel('Read Length (bp)')
axes[1,1].set_ylabel('Mean Quality Score')
axes[1,1].legend()

plt.tight_layout()
plt.savefig("results/qc_plots_python.png", dpi=150, bbox_inches='tight')
print("Plot saved as results/qc_plots_python.png!")
