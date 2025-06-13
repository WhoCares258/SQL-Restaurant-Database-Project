# 🍽️ YU Delights SQL Database Project

## 📌 Project Overview

This SQL project establishes a comprehensive relational database system for **YU Delights**, a multi-branch restaurant. The database simulates a real-world food service operation by capturing essential business entities such as **employees**, **branches**, **customers**, **orders**, **menu items**, **combos**, **payments**, **feedback**, and more.

The primary goals are:

- To model and manage operational data of a growing restaurant chain.
- To enable analytical insights through complex SQL queries.
- To ensure data consistency and enforce business rules via constraints and normalization.

---

## 🗺️ Entity-Relationship Diagram (ERD)

📎 *Insert your ERD image below*

![ERD Diagram](https://github.com/WhoCares258/SQL-Restaurant-Database-Project/blob/main/erd.png)

This ERD visualizes the structure and relationships of all major entities within the database, including foreign key dependencies, many-to-many junctions, and hierarchical data such as combo meals and their components.

---

## 🧠 Skills & Techniques Demonstrated

- **Relational Modeling**: Proper normalization, key constraints, and entity relationships.
- **Data Integrity**: Use of `CHECK`, `PRIMARY KEY`, and `FOREIGN KEY` constraints.
- **Data Population**: Large-scale insertions with logically structured sample data.
- **Complex Query Design**:
  - Use of **outer joins**, **grouping**, **aggregation**, **subqueries**, **pattern matching**, and **logical operators**.
  - **Multi-table joins** to simulate realistic reporting and analytics.
- **Business Insight Queries**: Analysis of employee tenure, order preferences, cost-per-customer behavior, and ingredient demand patterns.

---

## 📊 Summary of Analytical Queries

### 1. 📦 Combo-Only Orders  
Uses an **outer join** to identify orders that contain only combo sets without individual items. This helps understand the effectiveness and popularity of combos.

### 2. 🧂 Ingredient Analysis in Combo Sets  
A **4-table join with GROUP BY** identifies which combo sets use the most ingredients, and pinpoints the most commonly used ingredient — useful for inventory optimization.

### 3. 🧑‍🍳 Loyal Staff Members  
Applies **pattern matching** and **date filtering** to list long-serving waiters hired before a set date — useful for loyalty recognition.

### 4. 📉 Negative Feedback on Potatoes  
Combines **logical operators (AND/OR)** and **text search** to extract low-rated feedback or complaints that mention "Potatoes" — helpful for quality control.

### 5. 💰 Average Spend & Order Size per Person  
Uses **nested subqueries** to determine the average amount spent and number of items per diner — aiding in price strategy and portion planning.

---
