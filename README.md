# Financial-Fraud-Detection-SQL-Analysis

## Questions (The Ask)

### Problem Statement
This project involves the analysis of a large-scale dataset containing approximately 1.4 million credit card transaction records collected over the past two years. Out of this, nearly 1.3 million records are designated for training purposes. The dataset may contain inconsistencies, missing values, or anomalous entries that require systematic cleaning and validation.

### Objective
The objective is to build a robust analytical pipeline from raw data to actionable business intelligence:

#### Data Engineering (SQL): Systematic cleaning, validation, and resolution of data quality issues including duplicates, null values, and invalid entries.

#### Exploratory Data Analysis (SQL): Identifying the behavioral "DNA" of fraud, focusing on spending spikes, high-velocity transactions, and geographical anomalies.

#### Executive Visualization (Tableau): Developing a high-level Business Intelligence dashboard to visualize geographical and temporal "Hot Zones" of financial risk.

#### Predictive Modeling (Python): (Exploratory Phase) Investigating the feasibility of automated anomaly detection and machine learning classifiers to handle the 0.5% class imbalance.
Additionally, the processed data will be prepared for further analytical tasks, including potential modeling and visualization to support deeper insights into fraud detection.

## Data Preparation and Processing
To ensure the integrity of the 1.3 million records, a systematic data audit and cleaning pipeline was executed. Despite the large scale of the dataset, the following protocols were performed to maintain high data quality:

### Data Integrity Audit
A comprehensive audit was performed using SQL to identify structural and logical inconsistencies. The audit focused on three primary risk areas:

Null Values: Verified that critical fields, including amt, is_fraud, and trans_num, contained zero null entries.

Invalid Transaction Amounts: Identified and flagged any records with transaction values less than or equal to zero.

Primary Key Uniqueness: Checked the trans_num identifier for duplicate entries across the 1.3 million training rows.

### Validation Results
The processing phase confirmed a high level of data cleanliness:

Zero Nulls: 100% data density across all analyzed columns.

Zero Inconsistencies: All transaction amounts were found to be positive, valid numerical entries.

Zero Duplicates: Each of the 1,296,675 records (approx.) possesses a unique transaction identifier, ensuring no skewed results during behavioral analysis.

### Final Dataset State
Following the verification process, the dataset was deemed "Analysis-Ready." This clean state allows for the 8× fraud-to-legitimate value disparity to be reported as a statistically accurate finding rather than a result of data corruption.
### Key SQL Insights (Preliminary)
Initial Exploratory Data Analysis (EDA) has revealed critical behavioral markers that distinguish fraudulent activity from legitimate consumer behavior:

#### Extreme Class Imbalance
Analysis confirms that fraud accounts for only 0.5% of the total volume. This suggests that the dataset requires specialized sampling or algorithmic weighting to be effective in a predictive environment.

#### High-Value Targeting
A comparative analysis of transaction amounts shows a massive disparity in spending behavior.

##### Finding: Fraudulent transactions exhibit an average value 8x higher than legitimate transactions.
