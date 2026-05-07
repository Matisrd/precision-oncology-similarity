# Similarity Work

This folder contains a first patient similarity baseline using the same
patient-feature representation as the Neo4j graph.

## Method

Each patient is represented as a set of interpretable features:

```text
sex:Female
age_group:60-70
cancer_type:Breast Cancer
cancer_type_detailed:Breast Invasive Ductal Carcinoma
mutated_gene:TP53
rare_gene:ALK
common_gene:PIK3CA
```

The script supports:

- Jaccard similarity
- Weighted Jaccard similarity

The default weighted Jaccard weights are:

```text
sex = 0.25
age_group = 0.5
cancer_type = 2.0
cancer_type_detailed = 3.0
mutated_gene = 1.0
rare_gene = 2.0
common_gene = 1.5
```

## Run

```bash
python3 graph/similarity/patient_similarity.py \
  --csv "/Users/neilabenlamri/Library/Application Support/neo4j-desktop/Application/Data/dbmss/dbms-dd383344-d629-407c-a647-1a0683dcc55c/import/patient_static_features.csv" \
  --patient-id P-0000012 \
  --top-n 10
```

To save the result:

```bash
python3 graph/similarity/patient_similarity.py \
  --patient-id P-0000012 \
  --top-n 20 \
  --output results/similar_patients_P-0000012.csv
```

To use plain Jaccard:

```bash
python3 graph/similarity/patient_similarity.py \
  --patient-id P-0000012 \
  --metric jaccard
```

To change weights:

```bash
python3 graph/similarity/patient_similarity.py \
  --patient-id P-0000012 \
  --weight rare_gene=3 \
  --weight cancer_type_detailed=4
```
