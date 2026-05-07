# Graph Module

This folder contains the reproducible materials for the graph-based part of the precision oncology similarity project.

The patient-level data file is not committed to GitHub. To recreate the graph locally, place the shared file below in the Neo4j import folder:

```text
patient_static_features.csv
```

## Input Table

The graph is built from a cleaned patient-level feature table with these columns:

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

The original MSK-CHORD files used to create this table were:

```text
data_clinical_patient.txt
data_clinical_sample.txt
data_mutations.txt
```

These raw files should not be committed to GitHub.

## Static Patient-Feature Graph Schema

Each patient is represented as a central `Patient` node. Clinical and genomic attributes are represented as feature nodes.

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

Rare and common mutated genes are separated using patient-level gene frequency:

```text
rare gene: mutated in <5% of patients
common gene: mutated in >=5% of patients
```

This is a gene-level frequency definition, not a variant-level rarity definition.

## Recreate the Neo4j Graph

1. Create or open a local Neo4j database.
2. Copy `patient_static_features.csv` into the Neo4j `import` folder.
3. Open Neo4j Query/Browser.
4. Run the Cypher script:

```text
neo4j_import_patient_feature_graph.cypher
```

The script creates constraints, imports nodes, and creates relationships from the CSV.

## Similarity Work

The similarity module can use either:

1. `patient_static_features.csv` directly for Jaccard or weighted Jaccard similarity.
2. The Neo4j patient-feature graph to retrieve each patient's connected feature nodes.

Recommended feature types for similarity:

```text
sex
age_group
cancer_type
cancer_type_detailed
mutated_genes
rare_mutated_genes
common_mutated_genes
```

Similarity results can also be written back into Neo4j as direct patient-to-patient
relationships:

```text
(:Patient)-[:SIMILAR_TO {
  metric,
  score,
  shared_feature_count,
  source_feature_count,
  candidate_feature_count,
  shared_features
}]->(:Patient)
```

To import a similarity result CSV:

1. Copy `similar_patients_P-0000012.csv` into the Neo4j `import` folder.
2. Open Neo4j Query/Browser.
3. Set the import parameters:

```cypher
:param source_patient_id => 'P-0000012';
:param similarity_file => 'similar_patients_P-0000012.csv';
```

4. Run:

```text
neo4j_import_similarity_results.cypher
```

To visualize the source patient, similar patients, and their shared feature graph:

```cypher
MATCH path = (source:Patient {id: 'P-0000012'})-[sim:SIMILAR_TO]->(similar:Patient)
RETURN path
ORDER BY sim.score DESC
LIMIT 10;
```

To include the shared feature nodes:

```cypher
MATCH (source:Patient {id: 'P-0000012'})-[sim:SIMILAR_TO]->(similar:Patient)
MATCH (source)-[r1]->(feature)<-[r2]-(similar)
RETURN source, sim, similar, r1, feature, r2
LIMIT 100;
```

## Files in This Folder

```text
README.md
neo4j_import_patient_feature_graph.cypher
neo4j_import_similarity_results.cypher
graph_construction_summary.md
```
