🕵️ SQL Fraud Guard
⚡ Real-Time Fraud Detection Engine Powered by MySQL Triggers
Turning a passive database into an active financial security officer.
Traditional fraud systems analyze transactions after they happen.

SQL Fraud Guard stops suspicious activity the moment the transaction hits the database.
The database itself becomes an intelligent fraud detection engine.

🚀 What This Project Does

Instead of checking fraud in application code, this system:

1️⃣ Intercepts every transaction
2️⃣ Runs security checks via MySQL triggers
3️⃣ Calculates a risk score
4️⃣ Automatically flags suspicious accounts

All this happens in milliseconds inside the database.

⚡ Example
Transaction inserted
INSERT INTO TRANSACTION_DETAILS
(Account_ID, Amount, Location)
VALUES (1021, 300000, 'Delhi');
Fraud detection instantly triggered
Account_ID | Total_Score
-----------|------------
1021       | 110

🚨 The account is automatically flagged for investigation.

🧠 System Flow
User Transaction
       │
       ▼
MySQL Trigger Activated
       │
       ▼
Fraud Detection Rules
       │
       ▼
Risk Score Calculation
       │
       ▼
Fault Accounts Table

Instead of blocking transactions blindly, the system calculates a cumulative fraud score.
This allows investigators to prioritize the most dangerous accounts first.

🔎 Fraud Detection Engine
Rule	Description	Risk
💰 Whale Watcher	        Transaction > ₹200,000	    +40
👶 Minor Alert	          Account holder < 18	        +100
✈️ Teleportation	        Sudden location change	    +90
📈 Transaction Spike    	5× higher than normal	      +70

Each rule runs inside the database trigger.
No external service required.

⚙️ Engineering Challenges

Real projects are about problems solved, not just code written.

🧩 Data Integrity Paradox
<details> <summary>Why bulk data import failed (Error 1452)</summary>
Problem
Transactions were inserted before account records existed.
Foreign key constraints blocked the entire dataset.

Fix
SET FOREIGN_KEY_CHECKS = 0;
Temporarily disabled constraints during migration.

Result
✔ Successfully imported 50,000 transactions in one batch

</details>
⚠️ Constraint Conflict
<details> <summary>Why minors couldn't be tested (Error 3819)</summary>
Problem

A CHECK constraint prevented inserting users under 18.
This made testing the Minor Fraud Detection rule impossible.

Fix
ALTER TABLE person_info DROP CHECK age_constraint;
Trigger logic now handles the rule instead.

</details>
🚀 Trigger Performance Optimization
<details> <summary>Solving trigger locking issues</summary>
Problem

Triggers caused locking during large batch inserts.

Fix

Used:
ON DUPLICATE KEY UPDATE
Instead of inserting new rows, the database updates fraud scores efficiently.

Result
High-speed batch processing with minimal locking.

</details>
📊 Performance Test
Metric	Result
Transactions processed	50,000
Execution time	~4.7 seconds
High-risk accounts detected	1000+

All suspicious accounts are stored in:

FAULT_ACCOUNT

for manual review.

🧰 Tech Stack
Layer	Technology
Database	MySQL
Language	SQL
IDE	MySQL Workbench
Dataset	PaySim Mobile Money Fraud Dataset
