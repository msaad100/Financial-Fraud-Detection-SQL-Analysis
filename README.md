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

## Data Analysis & Behavioral Insights

This section analyzes the differences between legitimate and fraudulent transactions within the training dataset (approximately 1.3 million records), with the aim of identifying consistent behavioral patterns.

### 1. Transaction Amount Disparity

A clear difference exists in transaction amounts between fraud and non-fraud cases.

Fraudulent transactions show a much higher average amount, roughly eight times greater than legitimate transactions. In contrast, legitimate transactions remain relatively stable and lower in value.

Insight:  
Fraud in this dataset is generally associated with high-value transactions, indicating a tendency toward larger, more aggressive financial activity rather than small, frequent attempts.

### 2. Category-Based Behavior Analysis

To determine whether the higher fraud amounts were influenced by naturally expensive categories, transaction behavior was analyzed relative to category-specific averages.

#### 2.1 Signal Identification

Fraudulent transactions were compared against the average transaction value within each category. This ensured that the observed differences were not simply due to category-level pricing variations.

#### 2.2 Fraud Behavior Patterns

The analysis suggests two distinct patterns of fraudulent activity.

High-value fraud:  
In most categories, fraudulent transactions exceed the normal spending range by a noticeable margin. These cases are relatively easier to identify due to their deviation from typical behavior.

Stealth fraud:  
In a smaller number of categories, fraudulent transactions fall below the category average. This indicates attempts to mimic regular, low-value transactions, likely to avoid detection.

Insight:  
Fraudulent behavior is not consistent across all scenarios. While many cases involve large transaction amounts, some follow a more subtle pattern designed to blend in with normal activity.

### Key Takeaways

Fraudulent transactions are rare but tend to involve higher amounts.  
Most fraud cases show clear deviation from normal transaction values.  
A smaller portion follows patterns that resemble regular user behavior.  
Effective analysis should account for both obvious and subtle forms of fraud.
