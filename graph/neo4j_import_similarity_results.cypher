// Neo4j import script for patient similarity results.
//
// Before running:
// 1. Copy a similarity result CSV, for example
//    similar_patients_P-0000012.csv, into the Neo4j import folder.
// 2. In Neo4j Browser, set the source patient id and file name:
//    :param source_patient_id => 'P-0000012';
//    :param similarity_file => 'similar_patients_P-0000012.csv';
// 3. Run this script.
//
// Expected CSV columns:
// patient_id, similarity, shared_feature_count, target_feature_count,
// candidate_feature_count, shared_features

MATCH (source:Patient {id: $source_patient_id})
LOAD CSV WITH HEADERS FROM 'file:///' + $similarity_file AS row
MATCH (candidate:Patient {id: row.patient_id})
MERGE (source)-[r:SIMILAR_TO {metric: 'weighted_jaccard'}]->(candidate)
SET r.score = toFloat(row.similarity),
    r.shared_feature_count = toInteger(row.shared_feature_count),
    r.source_feature_count = toInteger(row.target_feature_count),
    r.candidate_feature_count = toInteger(row.candidate_feature_count),
    r.shared_features = split(row.shared_features, ';'),
    r.imported_from = $similarity_file;

MATCH (:Patient {id: $source_patient_id})-[r:SIMILAR_TO]->(candidate:Patient)
RETURN candidate.id AS similar_patient,
       r.score AS score,
       r.shared_feature_count AS shared_feature_count
ORDER BY score DESC;
