# Top-k Similarity Case Studies

This file summarizes top-k validation outputs for selected query patients. Results were computed from `patient_static_features.csv` using the same patient-feature representation as the Neo4j graph.

## P-0000015

Query cancer type: `Breast Cancer`

### jaccard

| Rank | Similar patient | Score | Shared cancer type | Shared detailed type | Shared common genes | Shared rare genes |
|---:|---|---:|---|---|---|---|
| 1 | P-0002387 | 0.555556 | Breast Cancer | Breast Invasive Ductal Carcinoma | PIK3CA | ESR1;GATA3 |
| 2 | P-0036370 | 0.555556 | Breast Cancer | Breast Invasive Ductal Carcinoma | PIK3CA;TP53 | GATA3 |
| 3 | P-0023004 | 0.5 | Breast Cancer | Breast Invasive Ductal Carcinoma | PIK3CA;TP53 | GATA3 |
| 4 | P-0036726 | 0.5 | Breast Cancer | Breast Invasive Ductal Carcinoma | TP53 | ESR1;GATA3 |
| 5 | P-0080147 | 0.5 | Breast Cancer | Breast Invasive Ductal Carcinoma | PIK3CA | ESR1;GATA3 |

### weighted_jaccard

| Rank | Similar patient | Score | Shared cancer type | Shared detailed type | Shared common genes | Shared rare genes |
|---:|---|---:|---|---|---|---|
| 1 | P-0002387 | 0.553398 | Breast Cancer | Breast Invasive Ductal Carcinoma | PIK3CA | ESR1;GATA3 |
| 2 | P-0036370 | 0.533981 | Breast Cancer | Breast Invasive Ductal Carcinoma | PIK3CA;TP53 | GATA3 |
| 3 | P-0080147 | 0.504425 | Breast Cancer | Breast Invasive Ductal Carcinoma | PIK3CA | ESR1;GATA3 |
| 4 | P-0036726 | 0.495652 | Breast Cancer | Breast Invasive Ductal Carcinoma | TP53 | ESR1;GATA3 |
| 5 | P-0023004 | 0.478261 | Breast Cancer | Breast Invasive Ductal Carcinoma | PIK3CA;TP53 | GATA3 |

## P-0000036

Query cancer type: `Non-Small Cell Lung Cancer`

### jaccard

| Rank | Similar patient | Score | Shared cancer type | Shared detailed type | Shared common genes | Shared rare genes |
|---:|---|---:|---|---|---|---|
| 1 | P-0006720 | 0.444444 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | ERBB2 |
| 2 | P-0007054 | 0.444444 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | ERBB2 |
| 3 | P-0060498 | 0.444444 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | ERBB2 |
| 4 | P-0014437 | 0.416667 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | IRS1;NOTCH4 |
| 5 | P-0001269 | 0.4 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | ERBB2 |

### weighted_jaccard

| Rank | Similar patient | Score | Shared cancer type | Shared detailed type | Shared common genes | Shared rare genes |
|---:|---|---:|---|---|---|---|
| 1 | P-0006720 | 0.428571 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | ERBB2 |
| 2 | P-0007054 | 0.428571 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | ERBB2 |
| 3 | P-0060498 | 0.428571 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | ERBB2 |
| 4 | P-0042173 | 0.415094 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | ERBB2 |
| 5 | P-0014437 | 0.404255 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | IRS1;NOTCH4 |

## P-0000012

Query cancer type: `Breast Cancer;Non-Small Cell Lung Cancer`

### jaccard

| Rank | Similar patient | Score | Shared cancer type | Shared detailed type | Shared common genes | Shared rare genes |
|---:|---|---:|---|---|---|---|
| 1 | P-0023406 | 0.226667 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | ATR;ATRX;NSD1;PIK3C2G;PTPRD;SMARCA4 |
| 2 | P-0016703 | 0.223301 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | KMT2C | ATR;ATRX;MAP3K1;NSD1;PDGFRA;PTPRD;PTPRS;PTPRT;RET |
| 3 | P-0073669 | 0.216216 | Non-Small Cell Lung Cancer | - | TP53 | ATR;BRIP1;CCNE1;CREBBP;RET;SMARCA4 |
| 4 | P-0017426 | 0.214286 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | BRIP1;FLT4;HGF;KDM5A;NSD1;PDGFRA |
| 5 | P-0060661 | 0.207547 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | BRIP1;FBXW7;FLT4;HGF;PDGFRA;PIK3R3;PTPRD;RET |

### weighted_jaccard

| Rank | Similar patient | Score | Shared cancer type | Shared detailed type | Shared common genes | Shared rare genes |
|---:|---|---:|---|---|---|---|
| 1 | P-0023406 | 0.231461 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | ATR;ATRX;NSD1;PIK3C2G;PTPRD;SMARCA4 |
| 2 | P-0016703 | 0.227496 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | KMT2C | ATR;ATRX;MAP3K1;NSD1;PDGFRA;PTPRD;PTPRS;PTPRT;RET |
| 3 | P-0043877 | 0.211618 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | ATR;FLT4;HGF;NSD1;PIK3C2G;PTPRT |
| 4 | P-0017426 | 0.208748 | Non-Small Cell Lung Cancer | Lung Adenocarcinoma | TP53 | BRIP1;FLT4;HGF;KDM5A;NSD1;PDGFRA |
| 5 | P-0057078 | 0.206823 | Breast Cancer;Non-Small Cell Lung Cancer | Breast Invasive Ductal Carcinoma | KMT2C;TP53 | CREBBP;FBXW7;MAP3K1;NSD1 |

## P-0069364

Query cancer type: `Colorectal Cancer`

### jaccard

| Rank | Similar patient | Score | Shared cancer type | Shared detailed type | Shared common genes | Shared rare genes |
|---:|---|---:|---|---|---|---|
| 1 | P-0080501 | 0.519774 | Colorectal Cancer | Colon Adenocarcinoma | APC;ARID1A;ATM;FAT1;KMT2C;KMT2D;PIK3CA;SMAD4;TP53 | ABL1;AGO2;AKT1;ALK;AMER1;ANKRD11;AR;ASXL1;ASXL2;ATR;ATRX;ATXN7;AXL;BARD1;BRCA1;BRCA2;BRD4;BRIP1;CALR;CARM1;CBL;CD276;CDH... |
| 2 | P-0073331 | 0.506008 | Colorectal Cancer | Colon Adenocarcinoma | APC;ARID1A;ATM;FAT1;KMT2C;KMT2D;PIK3CA;SMAD4;TP53 | ABL1;AGO2;ALK;AMER1;ANKRD11;APLNR;ARID1B;ARID2;ASXL1;ASXL2;ATRX;AXIN2;AXL;BCOR;BLM;BMPR1A;BRCA1;BRCA2;BRD4;BRIP1;CALR;CA... |
| 3 | P-0035133 | 0.486559 | - | - | APC;ARID1A;ATM;FAT1;KMT2C;KMT2D;PIK3CA;SMAD4;TP53 | ABL1;AGO2;ALK;ALOX12B;AMER1;ANKRD11;AR;ARID1B;ARID2;ASXL1;ATR;ATRX;AXIN2;AXL;BARD1;BCL2L11;BCOR;BLM;BRCA1;BRCA2;BRD4;BRI... |
| 4 | P-0033425 | 0.479256 | Colorectal Cancer | Colon Adenocarcinoma | APC;ARID1A;ATM;FAT1;KMT2C;KMT2D;PIK3CA;SMAD4;TP53 | AGO2;ALK;ALOX12B;AMER1;ANKRD11;AR;ARAF;ARID1B;ARID2;ASXL1;ATR;ATRX;AURKA;AXIN1;AXL;BCL10;BCOR;BLM;BRCA1;BRCA2;BRD4;BRIP1... |
| 5 | P-0089148 | 0.474376 | Colorectal Cancer | Colon Adenocarcinoma | APC;ARID1A;ATM;FAT1;KMT2C;KMT2D;PIK3CA;SMAD4;TP53 | ALK;AMER1;ANKRD11;AR;ARID1B;ARID2;ASXL1;ASXL2;ATR;ATRX;ATXN7;AURKA;AXL;B2M;BARD1;BCOR;BLM;BRAF;BRCA1;BRCA2;BRD4;BRIP1;CA... |

### weighted_jaccard

| Rank | Similar patient | Score | Shared cancer type | Shared detailed type | Shared common genes | Shared rare genes |
|---:|---|---:|---|---|---|---|
| 1 | P-0080501 | 0.521347 | Colorectal Cancer | Colon Adenocarcinoma | APC;ARID1A;ATM;FAT1;KMT2C;KMT2D;PIK3CA;SMAD4;TP53 | ABL1;AGO2;AKT1;ALK;AMER1;ANKRD11;AR;ASXL1;ASXL2;ATR;ATRX;ATXN7;AXL;BARD1;BRCA1;BRCA2;BRD4;BRIP1;CALR;CARM1;CBL;CD276;CDH... |
| 2 | P-0073331 | 0.505482 | Colorectal Cancer | Colon Adenocarcinoma | APC;ARID1A;ATM;FAT1;KMT2C;KMT2D;PIK3CA;SMAD4;TP53 | ABL1;AGO2;ALK;AMER1;ANKRD11;APLNR;ARID1B;ARID2;ASXL1;ASXL2;ATRX;AXIN2;AXL;BCOR;BLM;BMPR1A;BRCA1;BRCA2;BRD4;BRIP1;CALR;CA... |
| 3 | P-0035133 | 0.484917 | - | - | APC;ARID1A;ATM;FAT1;KMT2C;KMT2D;PIK3CA;SMAD4;TP53 | ABL1;AGO2;ALK;ALOX12B;AMER1;ANKRD11;AR;ARID1B;ARID2;ASXL1;ATR;ATRX;AXIN2;AXL;BARD1;BCL2L11;BCOR;BLM;BRCA1;BRCA2;BRD4;BRI... |
| 4 | P-0033425 | 0.478887 | Colorectal Cancer | Colon Adenocarcinoma | APC;ARID1A;ATM;FAT1;KMT2C;KMT2D;PIK3CA;SMAD4;TP53 | AGO2;ALK;ALOX12B;AMER1;ANKRD11;AR;ARAF;ARID1B;ARID2;ASXL1;ATR;ATRX;AURKA;AXIN1;AXL;BCL10;BCOR;BLM;BRCA1;BRCA2;BRD4;BRIP1... |
| 5 | P-0089148 | 0.473476 | Colorectal Cancer | Colon Adenocarcinoma | APC;ARID1A;ATM;FAT1;KMT2C;KMT2D;PIK3CA;SMAD4;TP53 | ALK;AMER1;ANKRD11;AR;ARID1B;ARID2;ASXL1;ASXL2;ATR;ATRX;ATXN7;AURKA;AXL;B2M;BARD1;BCOR;BLM;BRAF;BRCA1;BRCA2;BRD4;BRIP1;CA... |

## P-0000119

Query cancer type: `Colorectal Cancer`

### jaccard

| Rank | Similar patient | Score | Shared cancer type | Shared detailed type | Shared common genes | Shared rare genes |
|---:|---|---:|---|---|---|---|
| 1 | P-0019248 | 0.636364 | Colorectal Cancer | Colon Adenocarcinoma | APC;KRAS;PIK3CA;SMAD4 | EPHA5 |
| 2 | P-0086429 | 0.545455 | Colorectal Cancer | Colon Adenocarcinoma | APC;KRAS;PIK3CA;SMAD4 | - |
| 3 | P-0086521 | 0.545455 | Colorectal Cancer | Colon Adenocarcinoma | APC;KRAS;PIK3CA;SMAD4 | - |
| 4 | P-0075651 | 0.52381 | Colorectal Cancer | Colon Adenocarcinoma | APC;KRAS;PIK3CA;SMAD4 | - |
| 5 | P-0000744 | 0.5 | Colorectal Cancer | Colon Adenocarcinoma | APC;KRAS;PIK3CA;SMAD4 | - |

### weighted_jaccard

| Rank | Similar patient | Score | Shared cancer type | Shared detailed type | Shared common genes | Shared rare genes |
|---:|---|---:|---|---|---|---|
| 1 | P-0019248 | 0.609756 | Colorectal Cancer | Colon Adenocarcinoma | APC;KRAS;PIK3CA;SMAD4 | EPHA5 |
| 2 | P-0075651 | 0.539823 | Colorectal Cancer | Colon Adenocarcinoma | APC;KRAS;PIK3CA;SMAD4 | - |
| 3 | P-0028710 | 0.526316 | Colorectal Cancer | Colon Adenocarcinoma | APC;KRAS;PIK3CA;SMAD4 | - |
| 4 | P-0086429 | 0.512195 | Colorectal Cancer | Colon Adenocarcinoma | APC;KRAS;PIK3CA;SMAD4 | - |
| 5 | P-0086521 | 0.512195 | Colorectal Cancer | Colon Adenocarcinoma | APC;KRAS;PIK3CA;SMAD4 | - |

