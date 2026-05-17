# Validation Interpretation

This document summarizes the qualitative interpretation of the first top-k similarity validation run.

The results were computed for five selected query patients using:

```text
plain Jaccard
weighted Jaccard
```

The full top-k output is stored in:

```text
topk_similarity_results.csv
```

## Overall Observations

The first validation run suggests that the static patient-feature representation is producing interpretable neighbors.

Across the selected examples, top-ranked patients usually share:

```text
cancer type
detailed cancer type
common mutated genes
some rare mutated genes
```

Weighted Jaccard often produces similar top-ranked patients to plain Jaccard, but changes the ordering when cancer type, detailed cancer type, or rare gene overlap affects the weighted score.

## Query-Level Interpretation

### P-0000015

Query profile:

```text
Breast Cancer
Breast Invasive Ductal Carcinoma
Common genes: PIK3CA; TP53
Rare genes: ALK; CDK4; ESR1; GATA3; RNF43
```

Interpretation:

```text
The top-ranked patients are plausible matches. They share Breast Cancer, Breast Invasive Ductal Carcinoma, and breast-relevant mutation features such as PIK3CA, TP53, ESR1, and GATA3.
```

Metric comparison:

```text
Plain Jaccard and weighted Jaccard retrieve very similar patients. Weighted Jaccard slightly changes the ranking, but the top matches remain clinically interpretable because they share both cancer subtype and mutation features.
```

Validation assessment:

```text
Strong example. The retrieved patients are feature-level plausible matches.
```

### P-0000036

Query profile:

```text
Non-Small Cell Lung Cancer
Lung Adenocarcinoma
Common gene: TP53
Rare genes: AR; ERBB2; FBXW7; IRS1; NOTCH4; TSHR
```

Interpretation:

```text
The top-ranked patients consistently share Non-Small Cell Lung Cancer and Lung Adenocarcinoma. Most also share TP53 and at least one rare gene such as ERBB2, IRS1, or NOTCH4.
```

Metric comparison:

```text
The two metrics produce highly overlapping results. Weighted Jaccard slightly promotes patients with stronger weighted overlap in cancer subtype and rare genes.
```

Validation assessment:

```text
Strong example. The retrieved neighbors match the query patient's lung cancer context.
```

### P-0000012

Query profile:

```text
Breast Cancer; Non-Small Cell Lung Cancer
Breast Invasive Ductal Carcinoma; Lung Adenocarcinoma
Two samples
Common genes: KMT2C; TP53
Rare gene count: 24
```

Interpretation:

```text
This is a useful stress-test case because the query patient has multiple samples and multiple cancer types. The top-ranked results are mostly Non-Small Cell Lung Cancer / Lung Adenocarcinoma patients that share TP53 or KMT2C and several rare genes.
```

Metric comparison:

```text
Weighted Jaccard keeps the strongest lung cancer matches near the top and also retrieves one patient sharing both Breast Cancer and Non-Small Cell Lung Cancer features. This suggests that multi-cancer-type patients may produce mixed-neighborhood behavior.
```

Validation assessment:

```text
Moderate to strong example. The results are interpretable, but this case shows that patients with multiple cancer types can be harder to validate because similarity may reflect one disease context more strongly than another.
```

### P-0069364

Query profile:

```text
Colorectal Cancer
Colon Adenocarcinoma
High mutation burden
Mutated genes: 288
Rare genes: 279
Common genes: APC; ARID1A; ATM; FAT1; KMT2C; KMT2D; PIK3CA; SMAD4; TP53
```

Interpretation:

```text
The top-ranked results mostly share Colorectal Cancer, Colon Adenocarcinoma, and many common colorectal-associated genes such as APC, PIK3CA, SMAD4, and TP53. However, one highly ranked patient does not share the same cancer type, which suggests that very large mutation sets can sometimes dominate similarity.
```

Metric comparison:

```text
Plain Jaccard and weighted Jaccard are very similar for this high mutation burden case. This suggests that when the feature set is extremely large, both metrics can be driven by broad gene overlap.
```

Validation assessment:

```text
Useful limitation example. The result is partly plausible, but it highlights the need to handle high mutation burden patients carefully.
```

### P-0000119

Query profile:

```text
Colorectal Cancer
Colon Adenocarcinoma
Common genes: APC; KRAS; PIK3CA; SMAD4
Rare genes: EPHA5; HNF1A; MLL3; STAG2
```

Interpretation:

```text
The top-ranked patients are strong matches. They share Colorectal Cancer, Colon Adenocarcinoma, and the compact common gene profile APC, KRAS, PIK3CA, and SMAD4.
```

Metric comparison:

```text
Weighted Jaccard changes the ordering slightly but keeps the same biological interpretation. The top result also shares EPHA5, which supports its high rank.
```

Validation assessment:

```text
Strong example. This query shows that compact mutation profiles can produce clean, interpretable nearest neighbors.
```

## Metric-Level Summary

Plain Jaccard:

```text
Strength: simple and transparent.
Weakness: can be influenced by large feature sets, especially high mutation burden patients.
```

Weighted Jaccard:

```text
Strength: can emphasize clinically meaningful features such as detailed cancer type and rare mutated genes.
Weakness: current weights are manually chosen and require clinical justification.
```

In this first run, weighted Jaccard did not radically change the top-k lists for most query patients, but it did change the ordering and made some multi-feature matches more prominent.

## Validation Conclusions

The static patient-feature graph baseline passes an initial qualitative sanity check:

```text
1. Typical breast cancer and lung cancer query patients retrieve same-disease neighbors.
2. Compact colorectal mutation profiles produce interpretable top-k results.
3. Multi-cancer-type patients produce mixed but explainable neighborhoods.
4. High mutation burden patients expose a limitation: broad gene overlap can dominate similarity.
```

These observations support using the current graph as an interpretable baseline, while also motivating future improvements such as variant-level mutation features, clinically curated gene weights, and temporal treatment/progression information.

