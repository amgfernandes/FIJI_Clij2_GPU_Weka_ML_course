# %%
import glob
import pandas as pd
import glob
import seaborn as sns
import pingouin as pg
import matplotlib.pyplot as plt

# %%
'''Example to load all the individual result files'''

files = glob.glob("../5xFAD gr1/results/*Results*.csv")
file_count = len(files)

print(f"In total we have {file_count} files")

# %%
# create empty list
dataframes_list = []
  
# append datasets to the list 
for i in range(file_count):
    temp_df = pd.read_csv(files[i])
    dataframes_list.append(temp_df)
      
# # display datsets
# for dataset in dataframes_list:
#     display(dataset)

# %%
dataframes_list

# %%
df = pd.concat(dataframes_list, axis=0)
df

# %%
df.describe()

# %%
summary_df_gr1 = pd.read_csv('../5xFAD gr1/results/Summary.csv')
summary_df_gr1 ['Group'] = 'Group_1'
summary_df_gr1

# %%
summary_df_gr2 = pd.read_csv('../5xFAD gr2_WT/results/Summary.csv')
summary_df_gr2 ['Group'] = 'Group_2'
summary_df_gr2

# %%
summary_df_gr3 = pd.read_csv('../5xFAD gr3/results/Summary.csv')
summary_df_gr3 ['Group'] = 'Group_3'
summary_df_gr3

# %%
print(summary_df_gr1.describe())
print(summary_df_gr2.describe())
print(summary_df_gr3.describe())

# %%
df_together = pd.concat([summary_df_gr1, summary_df_gr2, summary_df_gr3])
df_together

# %%
plt.figure(figsize=(8, 8))
sns.boxplot(data = df_together, x='Group', y='Count', palette="Set3")
sns.swarmplot(data = df_together, x='Group', y='Count', color = "black")
plt.ylabel('Number of plaques', fontsize = 20)
plt.xlabel('Experiment', fontsize = 20)
plt.yticks(fontsize = 20)
plt.xticks(fontsize = 20)
sns.despine()
plt.tight_layout()
plt.savefig('Counts.png', dpi = 300)

# %%
'''Other way of representing the data'''

plt.figure(figsize=(10, 10))
sns.violinplot(data = df_together, x='Group', y='Count', palette="Set3")
sns.swarmplot(data = df_together, x='Group', y='Count', color = "black")
sns.despine()

# %% [markdown]
# # Pingouin is an open-source statistical package written in Python 3 
# 
# https://pingouin-stats.org/#
# 

# %%
pg.ttest(summary_df_gr1.Count, summary_df_gr2.Count)

# %% [markdown]
# # Is the data normal?

# %%
print(pg.normality(summary_df_gr1.Count))
print(pg.normality(summary_df_gr2.Count))
print(pg.normality(summary_df_gr3.Count))

# %% [markdown]
# ## The Kruskal-Wallis H-test 
# 
# The Kruskal-Wallis H-test tests the null hypothesis that the population median of all of the groups are equal. It is a non-parametric version of ANOVA. The test works on 2 or more independent samples, which may have different sizes. Due to the assumption that H has a chi square distribution, the number of samples in each group must not be too small. A typical rule is that each sample must have at least 5 measurements.

# %%
pg.kruskal(df_together, dv= 'Count', between= 'Group')

# %% [markdown]
# ## The Mann–Whitney U test (also called Wilcoxon rank-sum test) is a non-parametric test of the null hypothesis 

# %%
p1 = pg.mwu(summary_df_gr1.Count, summary_df_gr2.Count)
p1

# %%
p2 = pg.mwu(summary_df_gr1.Count, summary_df_gr3.Count)
p2

# %%
p3 = pg.mwu(summary_df_gr2.Count, summary_df_gr3.Count)
p3

# %% [markdown]
# # P-values correction for multiple comparisons.
# 
# 

# %%
'''Benjamini–Hochberg FDR correction of an array of p-values'''

pvals = [p1['p-val'].values[0], p2['p-val'].values[0], p3['p-val'].values[0]]
reject, pvals_corr = pg.multicomp(pvals, method='fdr_bh')
print(reject, pvals_corr)

# %% [markdown]
# # There are many ways to vizualize the data

# %%
df_together.head()

# %%
sns.pairplot(summary_df_gr1, height = 1.5, diag_kind="kde")

# %%
summary_df_gr1

# %%
sns.kdeplot(data = df_together.Minor)
sns.kdeplot(data = df_together.Major)

# %%
sns.kdeplot(data = df_together['Mean'])
sns.rugplot(data = df_together['Mean'], height= 0.1)

# %%
sns.barplot(data = df_together, x='Group', y='Count', palette="Set3")

# %%
sns.histplot(df_together.Count)

# %%
summary_df_gr3.Count.plot(kind='bar')

# %%



