# Graph Construction Summary

This document summarizes the static patient-feature graph constructed from the MSK-CHORD structured data.

## Goal

Build a simple, interpretable static patient-feature graph that can support patient similarity experiments.

The first version is not a graph neural network. It is a transparent baseline graph where each patient is connected to clinical and genomic feature nodes.

## Source Files

The cleaned patient-level feature table was generated from:

```text
data_clinical_patient.txt
data_clinical_sample.txt
data_mutations.txt
```

The derived table is:

```text
patient_static_features.csv
```

This CSV should be shared privately within the team if needed. It should not be committed to GitHub unless the project policy explicitly allows patient-level derived data in the repository.

## Derived Table Columns

```text
patient_id
sex
age_group
cancer_type
cancer_type_detailed
sample_ids
mutated_genes
rare_mutated_genes
common_mutated_genes
```

## Rare/Common Gene Definition

Rare and common genes were defined using patient-level gene frequency:

```text
rare gene: mutated in <5% of patients
common gene: mutated in >=5% of patients
```

This is a gene-level frequency definition. It does not distinguish specific variant-level rarity, such as EGFR L858R vs another EGFR variant.

## Graph Schema

```text
(:Patient)-[:HAS_SEX]->(:Sex)
(:Patient)-[:IN_AGE_GROUP]->(:AgeGroup)
(:Patient)-[:HAS_CANCER_TYPE]->(:CancerType)
(:Patient)-[:HAS_DETAILED_CANCER_TYPE]->(:CancerTypeDetailed)
(:Patient)-[:HAS_SAMPLE]->(:Sample)
(:Patient)-[:HAS_MUTATED_GENE]->(:Gene)
(:Patient)-[:HAS_RARE_MUTATED_GENE]->(:Gene)
(:Patient)-[:HAS_COMMON_MUTATED_GENE]->(:Gene)
```

## Observed Counts

The following counts were observed after import:

```text
Patient nodes: 24950
Sample nodes: 25040
Gene nodes: 524

HAS_CANCER_TYPE relationships: 25040
HAS_DETAILED_CANCER_TYPE relationships: 25040
HAS_SAMPLE relationships: 25040
HAS_MUTATED_GENE relationships: 186733
HAS_RARE_MUTATED_GENE relationships: 145363
HAS_COMMON_MUTATED_GENE relationships: 41370
```

The number of samples is slightly larger than the number of patients because some patients have more than one sample.

The rare and common mutated gene relationship counts sum to the total mutated gene relationship count:

```text
145363 + 41370 = 186733
```

## How the Similarity Teammate Can Use This

The similarity component can use either:

1. The CSV directly, where each patient is a row of features.
2. The Neo4j graph, where each patient is connected to feature nodes.

For Jaccard similarity, each patient can be represented as a set of features, for example:

```text
sex:Female
age_group:60-70
cancer_type:Breast Cancer
cancer_type_detailed:Breast Invasive Ductal Carcinoma
gene:TP53
rare_gene:ALK
common_gene:TP53
```

For weighted Jaccard similarity, feature types can receive different weights. For example, cancer type and rare mutated genes may receive higher weights than sex or age group, depending on the clinical question.

## Suggested Validation Queries

Count nodes:

```cypher
MATCH (p:Patient)
WITH count(p) AS patients
MATCH (s:Sample)
WITH patients, count(s) AS samples
MATCH (g:Gene)
WITH patients, samples, count(g) AS genes
MATCH (c:CancerType)
WITH patients, samples, genes, count(c) AS cancer_types
MATCH (d:CancerTypeDetailed)
WITH patients, samples, genes, cancer_types, count(d) AS detailed_cancer_types
MATCH (a:AgeGroup)
WITH patients, samples, genes, cancer_types, detailed_cancer_types, count(a) AS age_groups
MATCH (sx:Sex)
RETURN patients, samples, genes, cancer_types, detailed_cancer_types, age_groups, count(sx) AS sex_categories;
```

Count relationships:

```cypher
MATCH ()-[r]->()
RETURN type(r) AS relationship_type, count(r) AS count
ORDER BY relationship_type;
```

Inspect one patient:

```cypher
MATCH (p:Patient {id: 'P-0000012'})-[r]->(feature)
RETURN p.id AS patient_id, type(r) AS relationship_type, labels(feature) AS feature_labels, feature
LIMIT 50;
```

