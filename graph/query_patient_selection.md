# Query Patient Selection

This document proposes a small set of query patients for qualitative validation of the graph-based patient similarity baseline.

The goal is to choose representative patients that test different aspects of the similarity method, rather than selecting patients completely at random.

## Selection Criteria

The validation set should cover:

```text
1. A typical breast cancer patient
2. A typical lung cancer patient
3. A patient with multiple samples or multiple cancer types
4. A patient with many rare mutated genes / high mutation burden
5. A patient with a compact but clinically interpretable common mutation profile
```

This selection allows us to inspect whether the similarity method behaves reasonably across different patient profiles.

## Proposed Query Patients

| Query patient | Main reason for selection | Cancer type | Detailed cancer type | Age group | Sex | Samples | Mutated genes | Rare genes | Common genes |
|---|---|---|---|---|---|---:|---:|---:|---:|
| P-0000015 | Typical breast cancer case with common breast cancer-related genes | Breast Cancer | Breast Invasive Ductal Carcinoma | 40-50 | Female | 1 | 7 | 5 | 2 |
| P-0000036 | Typical lung cancer case | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | 60-70 | Female | 1 | 7 | 6 | 1 |
| P-0000012 | Multi-sample / multi-cancer-type case | Breast Cancer; Non-Small Cell Lung Cancer | Breast Invasive Ductal Carcinoma; Lung Adenocarcinoma | 60-70 | Female | 2 | 26 | 24 | 2 |
| P-0069364 | Rare-gene-heavy / high mutation burden case | Colorectal Cancer | Colon Adenocarcinoma | 80-90 | Female | 1 | 288 | 279 | 9 |
| P-0000119 | Compact colorectal case with common driver-like genes | Colorectal Cancer | Colon Adenocarcinoma | 60-70 | Female | 1 | 8 | 4 | 4 |

## Patient-Level Feature Notes

### P-0000015

Reason to include:

```text
Typical breast cancer example with a moderate number of genes.
Useful for checking whether top-k similar patients remain within breast cancer and share genes such as PIK3CA and TP53.
```

Key features:

```text
cancer_type: Breast Cancer
cancer_type_detailed: Breast Invasive Ductal Carcinoma
common_mutated_genes: PIK3CA; TP53
rare_mutated_genes: ALK; CDK4; ESR1; GATA3; RNF43
```

### P-0000036

Reason to include:

```text
Typical non-small cell lung cancer example.
Useful for checking whether lung adenocarcinoma patients are retrieved and whether shared TP53 or lung-relevant rare genes influence the ranking.
```

Key features:

```text
cancer_type: Non-Small Cell Lung Cancer
cancer_type_detailed: Lung Adenocarcinoma
common_mutated_genes: TP53
rare_mutated_genes: AR; ERBB2; FBXW7; IRS1; NOTCH4; TSHR
```

### P-0000012

Reason to include:

```text
Multi-sample and multi-cancer-type patient.
Useful stress test for the graph representation because the patient connects to both breast cancer and lung cancer features.
```

Key features:

```text
cancer_type: Breast Cancer; Non-Small Cell Lung Cancer
cancer_type_detailed: Breast Invasive Ductal Carcinoma; Lung Adenocarcinoma
sample_count: 2
common_mutated_genes: KMT2C; TP53
rare_gene_count: 24
```

Validation question:

```text
Does the similarity method retrieve breast cancer patients, lung cancer patients, or patients sharing both types of features?
```

### P-0069364

Reason to include:

```text
High mutation burden case with many rare mutated genes.
Useful for testing whether the similarity metric is dominated by large gene sets and whether weighted Jaccard behaves differently from plain Jaccard.
```

Key features:

```text
cancer_type: Colorectal Cancer
cancer_type_detailed: Colon Adenocarcinoma
mutated_gene_count: 288
rare_gene_count: 279
common_gene_count: 9
common_mutated_genes: APC; ARID1A; ATM; FAT1; KMT2C; KMT2D; PIK3CA; SMAD4; TP53
```

Validation question:

```text
Do top-k results reflect colorectal cancer similarity, or are they driven mostly by many shared genes?
```

### P-0000119

Reason to include:

```text
Compact colorectal cancer example with a small number of common genes.
Useful contrast against the high mutation burden colorectal case.
```

Key features:

```text
cancer_type: Colorectal Cancer
cancer_type_detailed: Colon Adenocarcinoma
mutated_gene_count: 8
common_mutated_genes: APC; KRAS; PIK3CA; SMAD4
rare_mutated_genes: EPHA5; HNF1A; MLL3; STAG2
```

Validation question:

```text
Does the method retrieve colorectal patients with similar compact driver-like mutation profiles?
```

## Recommended Validation Runs

For each selected query patient, generate top-k results using:

```text
plain Jaccard
weighted Jaccard
```

Recommended top-k:

```text
k = 5 or 10
```

The output should be reviewed for:

```text
shared cancer type
shared detailed cancer type
shared mutated genes
shared rare genes
shared common genes
whether the match is strong, moderate, or questionable
```

## Suggested Interpretation Focus

| Query patient | Main validation focus |
|---|---|
| P-0000015 | Does similarity retrieve breast invasive ductal carcinoma patients with shared PIK3CA/TP53-like profiles? |
| P-0000036 | Does similarity retrieve lung adenocarcinoma patients and avoid unrelated cancer types? |
| P-0000012 | How does the model handle patients with multiple cancer types and samples? |
| P-0069364 | Does high mutation burden distort the rankings? |
| P-0000119 | Does a compact colorectal mutation profile produce interpretable neighbors? |

