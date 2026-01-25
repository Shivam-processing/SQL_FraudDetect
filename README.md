# SQL_FraudDetect

This project is a real-time fraud monitoring engine built entirely in MySQL. Instead of relying on external apps, the database uses Triggers to automatically flag suspicious banking activity the moment a transaction is recorded.

📂 The Data Source(kaggle)
The system is powered by the PaySim Synthetic Dataset, a highly realistic simulation of mobile money transactions. It provides the "noise" (normal transfers) and the "signals" (fraudulent patterns) needed to test the detection logic.

🚀 Key Features & Logic
Every transaction is put through a "Stress Test." If it hits a red flag, points are added to a cumulative risk score in the FAULT_ACCOUNT table:
High-Value Detection (+40 pts): Flags any transaction exceeding 200,000.
Minor Account Protection (+100 pts): Identifies activity on accounts owned by users under 18.
Impossible Travel (+90 pts): Flags accounts used in different locations within a physically impossible timeframe.
Spending Spikes (+70 pts): Detects sudden jumps in spending compared to historical averages.

🛠️ Technical "Wins"
During this project, I handled real-world database constraints, including:

Resolving Error 1452: I managed Foreign Key conflicts by using SET FOREIGN_KEY_CHECKS = 0 during bulk data loads to ensure 50,000+ records migrated smoothly without breaking the system.

Trigger Optimization: Built ON DUPLICATE KEY UPDATE logic so that fraud scores accumulate dynamically as new evidence appears.

📊 How to Run
Import the PaySim CSV into your staging table.

Run the provided SQL script to build the tables and active triggers.

Check the "Fraud Leaderboard":
