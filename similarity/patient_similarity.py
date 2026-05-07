#!/usr/bin/env python3
"""Compute patient similarity from patient_static_features.csv.

The graph encodes patients as connected feature nodes. This script uses the
same patient-feature representation directly from the CSV so similarity can be
computed quickly and reproducibly.
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

import pandas as pd


DEFAULT_WEIGHTS = {
    "sex": 0.25,
    "age_group": 0.5,
    "cancer_type": 2.0,
    "cancer_type_detailed": 3.0,
    "mutated_gene": 1.0,
    "rare_gene": 2.0,
    "common_gene": 1.5,
}


@dataclass(frozen=True)
class PatientFeatures:
    patient_id: str
    features: frozenset[str]


def split_values(value: object) -> list[str]:
    if pd.isna(value):
        return []
    text = str(value).strip()
    if not text:
        return []
    return [part.strip() for part in text.split(";") if part.strip()]


def row_to_features(row: pd.Series) -> frozenset[str]:
    features: set[str] = set()

    for column in ("sex", "age_group"):
        value = row.get(column)
        if not pd.isna(value) and str(value).strip():
            features.add(f"{column}:{str(value).strip()}")

    for value in split_values(row.get("cancer_type")):
        features.add(f"cancer_type:{value}")

    for value in split_values(row.get("cancer_type_detailed")):
        features.add(f"cancer_type_detailed:{value}")

    for value in split_values(row.get("mutated_genes")):
        features.add(f"mutated_gene:{value}")

    for value in split_values(row.get("rare_mutated_genes")):
        features.add(f"rare_gene:{value}")

    for value in split_values(row.get("common_mutated_genes")):
        features.add(f"common_gene:{value}")

    return frozenset(features)


def load_patient_features(csv_path: Path) -> list[PatientFeatures]:
    df = pd.read_csv(csv_path, dtype=str, encoding="utf-8-sig").fillna("")
    required = {
        "patient_id",
        "sex",
        "age_group",
        "cancer_type",
        "cancer_type_detailed",
        "mutated_genes",
        "rare_mutated_genes",
        "common_mutated_genes",
    }
    missing = required.difference(df.columns)
    if missing:
        raise ValueError(f"CSV is missing required columns: {', '.join(sorted(missing))}")

    return [
        PatientFeatures(str(row["patient_id"]), row_to_features(row))
        for _, row in df.iterrows()
    ]


def feature_weight(feature: str, weights: dict[str, float]) -> float:
    feature_type = feature.split(":", 1)[0]
    return weights.get(feature_type, 1.0)


def jaccard(left: set[str] | frozenset[str], right: set[str] | frozenset[str]) -> float:
    union = left | right
    if not union:
        return 0.0
    return len(left & right) / len(union)


def weighted_jaccard(
    left: set[str] | frozenset[str],
    right: set[str] | frozenset[str],
    weights: dict[str, float],
) -> float:
    union = left | right
    if not union:
        return 0.0
    intersection_score = sum(feature_weight(feature, weights) for feature in left & right)
    union_score = sum(feature_weight(feature, weights) for feature in union)
    return intersection_score / union_score


def parse_weights(raw_weights: Iterable[str]) -> dict[str, float]:
    weights = DEFAULT_WEIGHTS.copy()
    for item in raw_weights:
        if "=" not in item:
            raise ValueError(f"Invalid weight '{item}'. Use feature_type=value.")
        key, value = item.split("=", 1)
        weights[key.strip()] = float(value)
    return weights


def find_similar_patients(
    patients: list[PatientFeatures],
    patient_id: str,
    metric: str,
    weights: dict[str, float],
    top_n: int,
) -> pd.DataFrame:
    by_id = {patient.patient_id: patient for patient in patients}
    if patient_id not in by_id:
        raise ValueError(f"Patient '{patient_id}' was not found in the CSV.")

    target = by_id[patient_id]
    rows = []
    for candidate in patients:
        if candidate.patient_id == patient_id:
            continue

        shared = target.features & candidate.features
        if metric == "jaccard":
            score = jaccard(target.features, candidate.features)
        else:
            score = weighted_jaccard(target.features, candidate.features, weights)

        rows.append(
            {
                "patient_id": candidate.patient_id,
                "similarity": round(score, 6),
                "shared_feature_count": len(shared),
                "target_feature_count": len(target.features),
                "candidate_feature_count": len(candidate.features),
                "shared_features": ";".join(sorted(shared)),
            }
        )

    return (
        pd.DataFrame(rows)
        .sort_values(["similarity", "shared_feature_count", "patient_id"], ascending=[False, False, True])
        .head(top_n)
        .reset_index(drop=True)
    )


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Find the most similar patients from patient_static_features.csv."
    )
    parser.add_argument(
        "--csv",
        type=Path,
        default=Path("/Users/neilabenlamri/Downloads/patient_static_features.csv"),
        help="Path to patient_static_features.csv.",
    )
    parser.add_argument("--patient-id", required=True, help="Patient id to compare against.")
    parser.add_argument("--top-n", type=int, default=10, help="Number of neighbours to return.")
    parser.add_argument(
        "--metric",
        choices=("jaccard", "weighted_jaccard"),
        default="weighted_jaccard",
        help="Similarity metric.",
    )
    parser.add_argument(
        "--weight",
        action="append",
        default=[],
        help="Override a default feature weight, e.g. --weight rare_gene=3.",
    )
    parser.add_argument("--output", type=Path, help="Optional CSV output path.")
    return parser


def main() -> None:
    args = build_parser().parse_args()
    weights = parse_weights(args.weight)
    patients = load_patient_features(args.csv)
    result = find_similar_patients(
        patients=patients,
        patient_id=args.patient_id,
        metric=args.metric,
        weights=weights,
        top_n=args.top_n,
    )

    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        result.to_csv(args.output, index=False)

    with pd.option_context("display.max_colwidth", 120, "display.width", 180):
        print(result.to_string(index=False))


if __name__ == "__main__":
    main()
