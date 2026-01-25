-- MySQL dump 10.13  Distrib 9.5.0, for macos15 (arm64)
--
-- Host: localhost    Database: FraudDetectionDB
-- ------------------------------------------------------
-- Server version	9.5.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Account_info`
--

DROP TABLE IF EXISTS `Account_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Account_info` (
  `Account_no` varchar(20) NOT NULL,
  `Aadhaar_no` varchar(12) DEFAULT NULL,
  `Account_type` varchar(20) DEFAULT NULL,
  `Balance` decimal(15,2) DEFAULT NULL,
  `branch` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Account_no`),
  KEY `Aadhaar_no` (`Aadhaar_no`),
  CONSTRAINT `account_info_ibfk_1` FOREIGN KEY (`Aadhaar_no`) REFERENCES `person_info` (`Aadhaar_no`),
  CONSTRAINT `account_info_chk_1` CHECK ((`balance` >= 1000))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `FAULT_ACCOUNT`
--

DROP TABLE IF EXISTS `FAULT_ACCOUNT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `FAULT_ACCOUNT` (
  `Fault_ID` int NOT NULL AUTO_INCREMENT,
  `Account_no` varchar(20) DEFAULT NULL,
  `Issue_ID` int DEFAULT NULL,
  `Total_Score` int DEFAULT NULL,
  `Detection_Date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Fault_ID`),
  KEY `Account_no` (`Account_no`),
  KEY `Issue_ID` (`Issue_ID`),
  CONSTRAINT `fault_account_ibfk_1` FOREIGN KEY (`Account_no`) REFERENCES `ACCOUNT_INFO` (`Account_no`),
  CONSTRAINT `fault_account_ibfk_2` FOREIGN KEY (`Issue_ID`) REFERENCES `ISSUE_INFORMATION` (`Issue_ID`)
) ENGINE=InnoDB AUTO_INCREMENT=11823 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ISSUE_INFORMATION`
--

DROP TABLE IF EXISTS `ISSUE_INFORMATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ISSUE_INFORMATION` (
  `Issue_ID` int NOT NULL,
  `Issue_Name` varchar(100) DEFAULT NULL,
  `Fraud_Score` int DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`Issue_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `person_info`
--

DROP TABLE IF EXISTS `person_info`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `person_info` (
  `Aadhaar_no` varchar(12) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `age` int DEFAULT NULL,
  `work_type` varchar(100) DEFAULT NULL,
  `phone_number` varchar(15) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`Aadhaar_no`),
  CONSTRAINT `person_info_chk_1` CHECK (((`age` >= 18) and (`age` <= 100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `stage_paysim`
--

DROP TABLE IF EXISTS `stage_paysim`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stage_paysim` (
  `step` int DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `amount` decimal(15,2) DEFAULT NULL,
  `nameOrig` varchar(20) DEFAULT NULL,
  `oldbalanceOrg` decimal(15,2) DEFAULT NULL,
  `newbalanceOrg` decimal(15,2) DEFAULT NULL,
  `nameDest` varchar(20) DEFAULT NULL,
  `oldbalanceDest` decimal(15,2) DEFAULT NULL,
  `newbalanceDest` decimal(15,2) DEFAULT NULL,
  `isFraud` int DEFAULT NULL,
  `isFlaggedFraud` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TRANSACTION_DETAILS`
--

DROP TABLE IF EXISTS `TRANSACTION_DETAILS`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TRANSACTION_DETAILS` (
  `Trans_ID` int NOT NULL AUTO_INCREMENT,
  `Account_No` varchar(20) DEFAULT NULL,
  `Trans_Type` varchar(20) DEFAULT NULL,
  `Amount` decimal(15,2) DEFAULT NULL,
  `Trans_Time` int DEFAULT NULL,
  `Receiver_Acc` varchar(20) DEFAULT NULL,
  `Location` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`Trans_ID`),
  KEY `Account_No` (`Account_No`),
  CONSTRAINT `transaction_details_ibfk_1` FOREIGN KEY (`Account_No`) REFERENCES `Account_info` (`Account_no`)
) ENGINE=InnoDB AUTO_INCREMENT=65550 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_velocity_fraud` AFTER INSERT ON `transaction_details` FOR EACH ROW BEGIN
    DECLARE trans_count INT;
    DECLARE existing_fault_id INT DEFAULT NULL;
    SELECT COUNT(*) INTO trans_count 
    FROM TRANSACTION_DETAILS 
    WHERE Account_No = NEW.Account_No 
    AND Trans_Time = NEW.Trans_Time;
    SELECT Fault_ID INTO existing_fault_id 
    FROM FAULT_ACCOUNT 
    WHERE Account_No = NEW.Account_No AND Issue_ID = 4
    LIMIT 1;   -- to stop and dont check further enteries when one entry is found
    IF trans_count > 5 THEN
        IF existing_fault_id IS NOT NULL THEN
            UPDATE FAULT_ACCOUNT 
            SET Total_Score = Total_Score + 80,
                Detection_Date = CURRENT_TIMESTAMP
            WHERE Fault_ID = existing_fault_id;
        ELSE
            INSERT INTO FAULT_ACCOUNT (Account_No, Issue_ID, Total_Score)
            VALUES (NEW.Account_No, 4, 80);
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_spending_spike` AFTER INSERT ON `transaction_details` FOR EACH ROW begin 
Declare avg_amount decimal(15,2);
declare existing_fault_id int default null;

select avg(amount) into avg_amount
from transaction_details 
where account_no= new.account_no
and  trans_id <new.trans_id;

select fault_id into existing_fault_id
FROM FAULT_ACCOUNT
Where account_No = new.account_no and issue_id = 6
limit 1;

if new.amount> (5* coalesce(avg_amount,new.amount)) then
if existing_fault_id is not null then 
update fault_account
set total_score=total_score + 70,
detection_date=current_timestamp
where fault_id=existing_fault_id;

else 
insert into fault_account (account_no,issue_id ,total_score)
values (new.account_no,6,70);
end if; 
end if;
end */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_high_value` AFTER INSERT ON `transaction_details` FOR EACH ROW BEGIN
    DECLARE existing_fault_id INT DEFAULT NULL;

    -- 1. Check if a record already exists for 'High Value Transaction' (Issue 3)
    SELECT Fault_ID INTO existing_fault_id 
    FROM FAULT_ACCOUNT 
    WHERE Account_No = NEW.Account_No AND Issue_ID = 3
    LIMIT 1;

    -- 2. Logic: If the amount is > 200,000, flag it
    IF NEW.Amount > 200000 THEN
        IF existing_fault_id IS NOT NULL THEN
            UPDATE FAULT_ACCOUNT 
            SET Total_Score = Total_Score + 40,
                Detection_Date = CURRENT_TIMESTAMP
            WHERE Fault_ID = existing_fault_id;
        ELSE
            INSERT INTO FAULT_ACCOUNT (Account_No, Issue_ID, Total_Score)
            VALUES (NEW.Account_No, 3, 40);
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_impossible_travel` AFTER INSERT ON `transaction_details` FOR EACH ROW BEGIN
    DECLARE previous_loc VARCHAR(50);
    DECLARE prev_time INT;
    DECLARE existing_fault_id INT DEFAULT NULL;

    -- 1. Using your exact column: 'Location'
    SELECT Location, Trans_Time 
    INTO previous_loc, prev_time
    FROM TRANSACTION_DETAILS
    WHERE Account_No = NEW.Account_No
    AND Trans_ID < NEW.Trans_ID
    ORDER BY Trans_ID DESC
    LIMIT 1;

    -- 2. Check for existing record
    SELECT Fault_ID INTO existing_fault_id 
    FROM FAULT_ACCOUNT 
    WHERE Account_No = NEW.Account_No AND Issue_ID = 6
    LIMIT 1;

    -- 3. Logic: If location changes but time (hour) is the same
    IF NEW.Location <> previous_loc AND NEW.Trans_Time = prev_time THEN
        IF existing_fault_id IS NOT NULL THEN
            UPDATE FAULT_ACCOUNT 
            SET Total_Score = Total_Score + 90,
                Detection_Date = CURRENT_TIMESTAMP
            WHERE Fault_ID = existing_fault_id;
        ELSE
            INSERT INTO FAULT_ACCOUNT (Account_No, Issue_ID, Total_Score)
            VALUES (NEW.Account_No, 6, 90);
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `CHECK_MIN_BALANCE` AFTER INSERT ON `transaction_details` FOR EACH ROW BEGIN 
    DECLARE CURRENT_BAL DECIMAL(15,2);
    DECLARE EXISTING_FAULT_ID INT DEFAULT NULL;

    SELECT Balance INTO CURRENT_BAL
    FROM Account_info
    WHERE Account_no = NEW.Account_No;

    SELECT FAULT_ID INTO EXISTING_FAULT_ID
    FROM FAULT_ACCOUNT 
    WHERE Account_No = NEW.Account_No AND Issue_ID = 2
    LIMIT 1;

    IF CURRENT_BAL < 1000 THEN 
        IF EXISTING_FAULT_ID IS NOT NULL THEN 
            UPDATE FAULT_ACCOUNT 
            SET TOTAL_SCORE = TOTAL_SCORE + 20,
                DETECTION_DATE = CURRENT_TIMESTAMP
            WHERE FAULT_ID = EXISTING_FAULT_ID;
        ELSE 
            -- FIX: Added Issue_ID and used VALUES
            INSERT INTO FAULT_ACCOUNT (Account_No, Issue_ID, TOTAL_SCORE)
            VALUES (NEW.Account_No, 2, 20);
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `check_minor_account` AFTER INSERT ON `transaction_details` FOR EACH ROW BEGIN
    DECLARE user_age INT;
    -- Using the correct table 'person_info' and column 'Aadhaar_no'
    SELECT P.age INTO user_age
    FROM person_info P
    JOIN Account_info A ON P.Aadhaar_no = A.Aadhaar_no
    WHERE A.Account_no = NEW.Account_No
    LIMIT 1;

    IF user_age < 18 THEN
        INSERT INTO FAULT_ACCOUNT (Account_No, Issue_ID, Total_Score)
        VALUES (NEW.Account_No, 1, 100)
        ON DUPLICATE KEY UPDATE Total_Score = Total_Score + 100;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping events for database 'FraudDetectionDB'
--

--
-- Dumping routines for database 'FraudDetectionDB'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-26  0:20:50
