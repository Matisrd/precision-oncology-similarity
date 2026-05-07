# Precision Oncology Patient Similarity

This project explores methods for assessing patient similarity in precision
oncology. The goal is to compare patients using structured clinical and genomic
features, then evaluate which similarity approach is most useful and
interpretable for downstream clinical reasoning.

The project focuses on three complementary approaches:

1. Rule-based patient similarity
2. Graph-based patient similarity
3. LLM-assisted patient similarity

## Project Goal

Precision oncology often relies on matching patients through shared clinical
and molecular characteristics. This repository investigates how patient
similarity can be represented, computed, and explained using complementary
methodological approaches.

The main research question is:

```text
How can we identify clinically meaningful similar patients using structured
oncology features, and how do rule-based, graph-based, and LLM-based approaches
compare?
```

## Approach 1: Rule-Based Similarity

To be completed by the rule-based similarity workstream.

## Approach 2: Graph-Based Similarity

The graph-based approach models each patient as a central node connected to
clinical and genomic feature nodes:

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

This representation supports interpretable graph queries, shared feature
inspection, and patient-to-patient similarity edges:

```text
(:Patient)-[:SIMILAR_TO {
  metric,
  score,
  shared_feature_count,
  shared_features
}]->(:Patient)
```

Graph import scripts are available in:

```text
graph/neo4j_import_patient_feature_graph.cypher
graph/neo4j_import_similarity_results.cypher
```

See [graph/README.md](graph/README.md) for Neo4j setup and import details.

The current graph implementation uses a derived patient-level feature table:

```text
patient_static_features.csv
```

This table was derived from the structured files:

```text
data_clinical_patient.txt
data_clinical_sample.txt
data_mutations.txt
```

The table contains:

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

Rare and common mutated genes are defined by patient-level gene frequency:

```text
rare gene: mutated in <5% of patients
common gene: mutated in >=5% of patients
```

These data files are used for the graph-based prototype and are not committed
to GitHub.

## Approach 3: LLM-Assisted Similarity

To be completed by the LLM-assisted similarity workstream.

## Repository Structure

```text
precision-oncology-similarity/
├── README.md
├── graph/
│   ├── README.md
│   ├── graph_construction_summary.md
│   ├── neo4j_import_patient_feature_graph.cypher
│   ├── neo4j_import_similarity_results.cypher
│   └── similarity/
│       ├── README.md
│       └── patient_similarity.py
├── rule_based/
│   └── README.md
├── llm/
│   └── README.md
├── results/               # generated locally, not committed
└── .gitignore
```

## Current Status

Implemented:

- static patient-feature graph schema
- Neo4j import script for patient-feature graph
- Neo4j import script for patient-to-patient similarity edges

Next steps:

- complete the rule-based similarity section
- complete the LLM-assisted similarity section
- compare outputs across the three approaches
- define evaluation criteria for clinically meaningful patient similarity

## Data and Version Control Policy

Do not commit:

- raw clinical/genomic data
- `patient_static_features.csv`
- generated result CSVs
- Neo4j database files

Commit:

- code
- documentation
- reproducible import scripts
- small examples that do not contain patient-level data
