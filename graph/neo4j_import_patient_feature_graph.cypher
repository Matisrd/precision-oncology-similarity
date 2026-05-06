// Neo4j import script for the MSK-CHORD static patient-feature graph.
//
// Before running:
// 1. Put patient_static_features.csv in the Neo4j import folder.
// 2. Connect to the target Neo4j database, usually `neo4j`.
// 3. Run this script in Neo4j Query/Browser.
//
// This script assumes the CSV has these columns:
// patient_id, sex, age_group, cancer_type, cancer_type_detailed,
// sample_ids, mutated_genes, rare_mutated_genes, common_mutated_genes

// ---------------------------------------------------------------------
// 1. Constraints
// ---------------------------------------------------------------------

CREATE CONSTRAINT patient_id_unique IF NOT EXISTS
FOR (p:Patient)
REQUIRE p.id IS UNIQUE;

CREATE CONSTRAINT sex_name_unique IF NOT EXISTS
FOR (s:Sex)
REQUIRE s.name IS UNIQUE;

CREATE CONSTRAINT age_group_name_unique IF NOT EXISTS
FOR (a:AgeGroup)
REQUIRE a.name IS UNIQUE;

CREATE CONSTRAINT cancer_type_name_unique IF NOT EXISTS
FOR (c:CancerType)
REQUIRE c.name IS UNIQUE;

CREATE CONSTRAINT cancer_type_detailed_name_unique IF NOT EXISTS
FOR (c:CancerTypeDetailed)
REQUIRE c.name IS UNIQUE;

CREATE CONSTRAINT sample_id_unique IF NOT EXISTS
FOR (s:Sample)
REQUIRE s.id IS UNIQUE;

CREATE CONSTRAINT gene_name_unique IF NOT EXISTS
FOR (g:Gene)
REQUIRE g.name IS UNIQUE;

// ---------------------------------------------------------------------
// 2. Patient nodes
// ---------------------------------------------------------------------

LOAD CSV WITH HEADERS FROM 'file:///patient_static_features.csv' AS row
MERGE (p:Patient {id: row.patient_id})
SET p.sex = row.sex,
    p.age_group = row.age_group;

// ---------------------------------------------------------------------
// 3. Sex nodes and relationships
// ---------------------------------------------------------------------

LOAD CSV WITH HEADERS FROM 'file:///patient_static_features.csv' AS row
MATCH (p:Patient {id: row.patient_id})
WITH p, row
WHERE row.sex IS NOT NULL AND row.sex <> ''
MERGE (s:Sex {name: row.sex})
MERGE (p)-[:HAS_SEX]->(s);

// ---------------------------------------------------------------------
// 4. Age group nodes and relationships
// ---------------------------------------------------------------------

LOAD CSV WITH HEADERS FROM 'file:///patient_static_features.csv' AS row
MATCH (p:Patient {id: row.patient_id})
WITH p, row
WHERE row.age_group IS NOT NULL AND row.age_group <> ''
MERGE (a:AgeGroup {name: row.age_group})
MERGE (p)-[:IN_AGE_GROUP]->(a);

// ---------------------------------------------------------------------
// 5. Cancer type nodes and relationships
// ---------------------------------------------------------------------

LOAD CSV WITH HEADERS FROM 'file:///patient_static_features.csv' AS row
MATCH (p:Patient {id: row.patient_id})
WITH p, split(row.cancer_type, ';') AS cancer_types
UNWIND cancer_types AS cancer_type
WITH p, trim(cancer_type) AS cancer_type
WHERE cancer_type <> ''
MERGE (c:CancerType {name: cancer_type})
MERGE (p)-[:HAS_CANCER_TYPE]->(c);

// ---------------------------------------------------------------------
// 6. Detailed cancer type nodes and relationships
// ---------------------------------------------------------------------

LOAD CSV WITH HEADERS FROM 'file:///patient_static_features.csv' AS row
MATCH (p:Patient {id: row.patient_id})
WITH p, split(row.cancer_type_detailed, ';') AS detailed_types
UNWIND detailed_types AS detailed_type
WITH p, trim(detailed_type) AS detailed_type
WHERE detailed_type <> ''
MERGE (c:CancerTypeDetailed {name: detailed_type})
MERGE (p)-[:HAS_DETAILED_CANCER_TYPE]->(c);

// ---------------------------------------------------------------------
// 7. Sample nodes and relationships
// ---------------------------------------------------------------------

LOAD CSV WITH HEADERS FROM 'file:///patient_static_features.csv' AS row
MATCH (p:Patient {id: row.patient_id})
WITH p, split(row.sample_ids, ';') AS sample_ids
UNWIND sample_ids AS sample_id
WITH p, trim(sample_id) AS sample_id
WHERE sample_id <> ''
MERGE (s:Sample {id: sample_id})
MERGE (p)-[:HAS_SAMPLE]->(s);

// ---------------------------------------------------------------------
// 8. Gene nodes and all mutated gene relationships
// ---------------------------------------------------------------------

LOAD CSV WITH HEADERS FROM 'file:///patient_static_features.csv' AS row
MATCH (p:Patient {id: row.patient_id})
WITH p, split(row.mutated_genes, ';') AS genes
UNWIND genes AS gene
WITH p, trim(gene) AS gene
WHERE gene <> ''
MERGE (g:Gene {name: gene})
MERGE (p)-[:HAS_MUTATED_GENE]->(g);

// ---------------------------------------------------------------------
// 9. Rare mutated gene relationships
// ---------------------------------------------------------------------

LOAD CSV WITH HEADERS FROM 'file:///patient_static_features.csv' AS row
MATCH (p:Patient {id: row.patient_id})
WITH p, split(row.rare_mutated_genes, ';') AS genes
UNWIND genes AS gene
WITH p, trim(gene) AS gene
WHERE gene <> ''
MATCH (g:Gene {name: gene})
MERGE (p)-[:HAS_RARE_MUTATED_GENE]->(g);

// ---------------------------------------------------------------------
// 10. Common mutated gene relationships
// ---------------------------------------------------------------------

LOAD CSV WITH HEADERS FROM 'file:///patient_static_features.csv' AS row
MATCH (p:Patient {id: row.patient_id})
WITH p, split(row.common_mutated_genes, ';') AS genes
UNWIND genes AS gene
WITH p, trim(gene) AS gene
WHERE gene <> ''
MATCH (g:Gene {name: gene})
MERGE (p)-[:HAS_COMMON_MUTATED_GENE]->(g);

// ---------------------------------------------------------------------
// 11. Optional validation queries
// ---------------------------------------------------------------------

MATCH (p:Patient)
RETURN count(p) AS patient_count;

MATCH (s:Sample)
RETURN count(s) AS sample_count;

MATCH (g:Gene)
RETURN count(g) AS gene_count;

MATCH ()-[r]->()
RETURN type(r) AS relationship_type, count(r) AS count
ORDER BY relationship_type;

