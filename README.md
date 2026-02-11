# Library-Operations-and-Risk-Analysis

## Project Overview

This project analyzes simulated library transaction data to evaluate borrowing behavior, overdue risk, revenue exposure, and operational patterns across members, branches, and book categories.

The objective to demonstrate how SQL can be used to perform structured operational analysis on relational data.

The dataset is synthetically generated to simulate realistic library operations.


## Assumptions

To ensure consistency and reproducibility, the following assumptions are applied:

- Standard return period: 30 days

- Fine policy: $0.50 per overdue day

- Analysis cutoff date: 2024-08-31

- Non-returned books are treated as returned on the analysis date for overdue calculations


## Objectives
  
1. Build a unified issue-level analytical dataset from normalized relational tables

2. Identify member-level borrowing risk and fine exposure

3. Detect high-risk members using defined thresholds

4. Compare revenue and overdue exposure at the branch level

5. Perform cohort analysis (new vs existing members)

6. Evaluate category-level risk and revenue patterns

7. Assess employee workload distribution

8. Apply Pareto analysis to measure concentration of overdue behavior


## Database Structure

The project uses the following relational tables:

- members

- books

- issued_status

- return_status

- employees

- branch

ER diagram is included in the diagrams/ folder.


## Steps to Reproduce

1. Run 01_schema.sql to create tables and constraints.

2. Run 02_data_inserts.sql to populate the dataset.

3. Run 03_analysis_queries.sql to generate analytical outputs.

**Note:** All queries are written in standard SQL (tested in MySQL).


## Results

Query outputs and visual results are available in the results/ folder.

A detailed breakdown of objectives, analysis steps, observations, and recommendations is documented here:\
[Library Operations and Risk Analysis - Full Report](https://anonymousraven.notion.site/Library-Operations-and-Risk-Analysis-303e78ab9b8e8022bcf2f31cbe211c1b)


## Skills Demonstrated

- Relational data modeling

- Analytical SQL (aggregations, CTEs, window functions)

- Risk segmentation logic

- Cohort analysis

- Pareto analysis

- Data validation and edge case handling
