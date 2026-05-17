# Validation Strategy

This document describes the validation plan for the graph-based patient similarity baseline.

## Validation Goal

The goal is not to report a single fixed accuracy score. Clinical similarity is subjective and depends on the clinical question. Instead, we validate whether the retrieved top-k similar patients share interpretable and clinically meaningful features with the query patient.

The validation focuses on three questions:

```text
1. Do the top-k similar patients share meaningful clinical or genomic features with the query patient?
2. Does weighted Jaccard produce more clinically interpretable matches than plain Jaccard?
3. Where does the current static graph baseline work well, and where does it produce questionable matches?
```

## Validation Type

We use qualitative case-study validation.

For selected query patients, we inspect the top-k retrieved patients and explain the similarity using feature-level evidence:

```text
shared cancer type
shared detailed cancer type
shared mutated genes
shared rare mutated genes
shared common mutated genes
shared age group
shared sex
```

This makes the similarity output transparent and easier to discuss with domain experts.

## Query Patient Selection

Query patients should be selected to cover different clinical and genomic situations rather than chosen completely at random.

Suggested selection criteria:

```text
1. One breast cancer patient
2. One lung cancer patient
3. One patient with multiple samples or multiple cancer types
4. One patient with several rare mutated genes
5. One patient dominated by common mutated genes
```

This gives a small but diverse validation set and helps show how the similarity method behaves across different patient profiles.

Example candidate patients already observed during graph construction:

```text
P-0000012
P-0000015
P-0000036
```

These are preliminary examples only. Final query patients should be selected after inspecting the cleaned feature table.

## Similarity Metrics to Compare

We compare at least two metrics:

```text
Plain Jaccard similarity
Weighted Jaccard similarity
```

Plain Jaccard treats all features equally. Weighted Jaccard gives different importance to different feature types.

The current weighted Jaccard baseline uses feature-level weights such as:

```text
sex = low weight
age_group = low to moderate weight
cancer_type = high weight
cancer_type_detailed = higher weight
mutated_gene = moderate weight
rare_gene = high weight
common_gene = moderate weight
```

The exact weights should be reported clearly because they influence the final ranking.

## Top-k Case Study Template

For each query patient, generate top-k similar patients using both plain Jaccard and weighted Jaccard.

Recommended value:

```text
k = 5 or 10
```

Each result should be summarized using a table like this:

```text
Query patient:
Metric:

Rank | Similar patient | Score | Shared cancer type | Shared detailed cancer type | Shared genes | Shared rare genes | Interpretation
-----|-----------------|-------|--------------------|-----------------------------|--------------|-------------------|---------------
1    |                 |       |                    |                             |              |                   |
2    |                 |       |                    |                             |              |                   |
3    |                 |       |                    |                             |              |                   |
```

The interpretation column should answer:

```text
Why was this patient retrieved?
Does the match make clinical or biological sense?
Is the match strong, moderate, or questionable?
```

## Feature-Level Interpretation

Similarity results should be explained using feature categories rather than only reporting scores.

Examples:

```text
Strong match:
Both patients share the same detailed cancer type and multiple mutated genes, including rare mutated genes.

Moderate match:
Both patients share the same broad cancer type and one common mutated gene, but differ in detailed subtype.

Questionable match:
Patients share several common genes but have different cancer types, suggesting that common mutations may dominate the similarity score.
```

## Metric Comparison Plan

For each query patient, compare the top-k list from plain Jaccard and weighted Jaccard.

Key questions:

```text
1. How much overlap is there between the two top-k lists?
2. Does weighted Jaccard rank patients with the same cancer type higher?
3. Does weighted Jaccard prioritize shared rare mutated genes?
4. Does plain Jaccard over-rank patients because of many low-specificity shared features?
5. Are there cases where weighting makes the ranking worse or harder to justify?
```

The comparison should be written qualitatively. For example:

```text
Weighted Jaccard produced more interpretable matches for this query patient because the top-ranked patients shared the same detailed cancer type and rare mutated genes.
```

or:

```text
Plain and weighted Jaccard produced similar rankings, suggesting that the query patient's strongest features were already captured by unweighted feature overlap.
```

## Neo4j Visualization Validation

After top-k similarity results are generated, the results can be imported back into Neo4j using patient-to-patient `SIMILAR_TO` relationships.

The graph can then be inspected visually:

```text
(:Patient)-[:SIMILAR_TO]->(:Patient)
```

For explanation, shared feature nodes can be shown:

```text
(query:Patient)-[]->(feature)<-[]-(similar:Patient)
```

This helps demonstrate that the similarity score is based on visible shared features in the graph.

## Validation Outputs

The validation section should produce:

```text
1. A short description of the validation strategy
2. A list of selected query patients and why they were selected
3. Top-k tables for each query patient
4. A comparison of plain Jaccard and weighted Jaccard
5. A short discussion of strengths, weaknesses, and limitations
```

## Limitations

Current limitations:

```text
1. No clinician-reviewed ground truth similarity labels are available yet.
2. Validation is qualitative and based on selected case studies.
3. Rare/common mutation status is defined by internal patient-level gene frequency, not external clinical databases.
4. Mutation features are gene-level, not variant-level.
5. Treatment, response, relapse, and progression are not included in the current static graph.
6. Weighted Jaccard weights are manually chosen and should be clinically justified or tuned in future work.
7. Broad cancer type and detailed cancer type can strongly affect similarity, so results may depend on how these features are weighted.
```

## Future Temporal Validation

The current graph is static. A future temporal graph could include time-stamped events:

```text
diagnosis
treatment start
treatment end
response
relapse
progression
death or last follow-up
```

Future validation could then compare patient trajectories rather than only static feature overlap.

Possible future similarity methods:

```text
sequence alignment
dynamic time warping
temporal graph similarity
trajectory embeddings
temporal graph neural networks
```

The validation question would shift from:

```text
Do these patients share static features?
```

to:

```text
Do these patients follow similar disease and treatment trajectories over time?
```

