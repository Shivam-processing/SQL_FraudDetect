DROP DATABASE IF EXISTS FraudDetectionDB;

CREATE DATABASE FraudDetectionDB;
USE FraudDetectionDB;


-- =========================
-- 1. CUSTOMER
-- =========================

CREATE TABLE person_info (
    Aadhaar_no VARCHAR(12) PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    age INT,
    work_type VARCHAR(100),
    phone_number VARCHAR(15),
    city VARCHAR(100),

    CHECK (age IS NULL OR (age >= 0 AND age <= 100))
);


-- =========================
-- 2. ACCOUNT
-- =========================

CREATE TABLE Account_info (
    Account_no VARCHAR(20) PRIMARY KEY,
    Aadhaar_no VARCHAR(12),
    Account_type VARCHAR(20),
    Balance DECIMAL(15,2),
    branch VARCHAR(50),

    FOREIGN KEY (Aadhaar_no)
        REFERENCES person_info(Aadhaar_no)
);


-- =========================
-- 3. FRAUD RULES
-- =========================

CREATE TABLE ISSUE_INFORMATION (
    Issue_ID INT PRIMARY KEY,
    Issue_Name VARCHAR(100),
    Fraud_Score INT,
    Description TEXT
);


INSERT INTO ISSUE_INFORMATION
(Issue_ID, Issue_Name, Fraud_Score, Description)
VALUES
(1, 'Minor Account', 100, 'Transaction performed by an account holder below 18'),
(2, 'Low Balance', 20, 'Account balance below 1000'),
(3, 'High Value Transaction', 40, 'Transaction amount greater than 200000'),
(4, 'Velocity Fraud', 80, 'More than 5 transactions in the same time bucket'),
(5, 'Spending Spike', 70, 'Transaction exceeds 5 times historical average'),
(6, 'Impossible Travel', 90, 'Same account used from different locations in same time bucket');


-- =========================
-- 4. FLAGGED ACCOUNTS
-- =========================

CREATE TABLE FAULT_ACCOUNT (
    Fault_ID INT AUTO_INCREMENT PRIMARY KEY,
    Account_no VARCHAR(20) NOT NULL,
    Issue_ID INT NOT NULL,
    Total_Score INT DEFAULT 0,
    Detection_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (Account_no)
        REFERENCES Account_info(Account_no),

    FOREIGN KEY (Issue_ID)
        REFERENCES ISSUE_INFORMATION(Issue_ID),

    UNIQUE (Account_no, Issue_ID)
);


-- =========================
-- 5. TRANSACTIONS
-- =========================

CREATE TABLE TRANSACTION_DETAILS (
    Trans_ID INT AUTO_INCREMENT PRIMARY KEY,
    Account_No VARCHAR(20) NOT NULL,
    Trans_Type VARCHAR(20),
    Amount DECIMAL(15,2),
    Trans_Time INT,
    Receiver_Acc VARCHAR(20),
    Location VARCHAR(50),

    FOREIGN KEY (Account_No)
        REFERENCES Account_info(Account_no),

    INDEX idx_account_time (Account_No, Trans_Time),
    INDEX idx_account_trans (Account_No, Trans_ID)
);


-- =========================
-- 6. RAW PAYSIM DATA
-- =========================

CREATE TABLE stage_paysim (
    step INT,
    type VARCHAR(20),
    amount DECIMAL(15,2),

    nameOrig VARCHAR(20),
    oldbalanceOrg DECIMAL(15,2),
    newbalanceOrg DECIMAL(15,2),

    nameDest VARCHAR(20),
    oldbalanceDest DECIMAL(15,2),
    newbalanceDest DECIMAL(15,2),

    isFraud INT,
    isFlaggedFraud INT
);


DELIMITER $$


-- =========================
-- VELOCITY FRAUD
-- =========================

CREATE TRIGGER check_velocity_fraud
AFTER INSERT ON TRANSACTION_DETAILS
FOR EACH ROW

BEGIN

    DECLARE trans_count INT DEFAULT 0;

    SELECT COUNT(*)
    INTO trans_count
    FROM TRANSACTION_DETAILS
    WHERE Account_No = NEW.Account_No
      AND Trans_Time = NEW.Trans_Time;

    IF trans_count > 5 THEN

        INSERT INTO FAULT_ACCOUNT
        (Account_no, Issue_ID, Total_Score)

        VALUES
        (NEW.Account_No, 4, 80)

        ON DUPLICATE KEY UPDATE
            Total_Score = Total_Score + 80,
            Detection_Date = CURRENT_TIMESTAMP;

    END IF;

END $$



-- =========================
-- SPENDING SPIKE
-- =========================

CREATE TRIGGER check_spending_spike
AFTER INSERT ON TRANSACTION_DETAILS
FOR EACH ROW

BEGIN

    DECLARE avg_amount DECIMAL(15,2);

    SELECT AVG(Amount)
    INTO avg_amount
    FROM TRANSACTION_DETAILS
    WHERE Account_No = NEW.Account_No
      AND Trans_ID < NEW.Trans_ID;

    IF avg_amount IS NOT NULL
       AND NEW.Amount > (5 * avg_amount) THEN

        INSERT INTO FAULT_ACCOUNT
        (Account_no, Issue_ID, Total_Score)

        VALUES
        (NEW.Account_No, 5, 70)

        ON DUPLICATE KEY UPDATE
            Total_Score = Total_Score + 70,
            Detection_Date = CURRENT_TIMESTAMP;

    END IF;

END $$



-- =========================
-- HIGH VALUE TRANSACTION
-- =========================

CREATE TRIGGER check_high_value
AFTER INSERT ON TRANSACTION_DETAILS
FOR EACH ROW

BEGIN

    IF NEW.Amount > 200000 THEN

        INSERT INTO FAULT_ACCOUNT
        (Account_no, Issue_ID, Total_Score)

        VALUES
        (NEW.Account_No, 3, 40)

        ON DUPLICATE KEY UPDATE
            Total_Score = Total_Score + 40,
            Detection_Date = CURRENT_TIMESTAMP;

    END IF;

END $$



-- =========================
-- IMPOSSIBLE TRAVEL
-- =========================

CREATE TRIGGER check_impossible_travel
AFTER INSERT ON TRANSACTION_DETAILS
FOR EACH ROW

BEGIN

    DECLARE previous_loc VARCHAR(50) DEFAULT NULL;
    DECLARE previous_time INT DEFAULT NULL;

    SELECT Location, Trans_Time
    INTO previous_loc, previous_time

    FROM TRANSACTION_DETAILS

    WHERE Account_No = NEW.Account_No
      AND Trans_ID < NEW.Trans_ID

    ORDER BY Trans_ID DESC
    LIMIT 1;


    IF previous_loc IS NOT NULL
       AND NEW.Location IS NOT NULL
       AND NEW.Location <> previous_loc
       AND NEW.Trans_Time = previous_time THEN

        INSERT INTO FAULT_ACCOUNT
        (Account_no, Issue_ID, Total_Score)

        VALUES
        (NEW.Account_No, 6, 90)

        ON DUPLICATE KEY UPDATE
            Total_Score = Total_Score + 90,
            Detection_Date = CURRENT_TIMESTAMP;

    END IF;

END $$



-- =========================
-- LOW BALANCE
-- =========================

CREATE TRIGGER check_min_balance
AFTER INSERT ON TRANSACTION_DETAILS
FOR EACH ROW

BEGIN

    DECLARE current_balance DECIMAL(15,2);

    SELECT Balance
    INTO current_balance
    FROM Account_info
    WHERE Account_no = NEW.Account_No;


    IF current_balance IS NOT NULL
       AND current_balance < 1000 THEN

        INSERT INTO FAULT_ACCOUNT
        (Account_no, Issue_ID, Total_Score)

        VALUES
        (NEW.Account_No, 2, 20)

        ON DUPLICATE KEY UPDATE
            Total_Score = Total_Score + 20,
            Detection_Date = CURRENT_TIMESTAMP;

    END IF;

END $$



-- =========================
-- MINOR ACCOUNT
-- =========================

CREATE TRIGGER check_minor_account
AFTER INSERT ON TRANSACTION_DETAILS
FOR EACH ROW

BEGIN

    DECLARE user_age INT DEFAULT NULL;

    SELECT P.age
    INTO user_age

    FROM person_info P

    JOIN Account_info A
        ON P.Aadhaar_no = A.Aadhaar_no

    WHERE A.Account_no = NEW.Account_No

    LIMIT 1;


    IF user_age IS NOT NULL
       AND user_age < 18 THEN

        INSERT INTO FAULT_ACCOUNT
        (Account_no, Issue_ID, Total_Score)

        VALUES
        (NEW.Account_No, 1, 100)

        ON DUPLICATE KEY UPDATE
            Total_Score = Total_Score + 100,
            Detection_Date = CURRENT_TIMESTAMP;

    END IF;

END $$


DELIMITER ;
