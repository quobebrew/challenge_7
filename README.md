## Credit Card Fraud Detection Analysis

Fraud is prevalent these days, affecting businesses of all sizes. While advanced technologies like machine learning and artificial intelligence aid in fraud detection, robust data analytics remains crucial for identifying suspicious activities.

This assignment focuses on leveraging SQL skills to analyze historical credit card transactions and consumption patterns to identify potential fraudulent transactions.

### Tasks

1. **Data Modeling**: Define a database model to store credit card transaction data and create a PostgreSQL database based on the model.
   
2. **Data Engineering**: Develop a database schema in PostgreSQL and import data from provided CSV files into the database.
   
3. **Data Analysis**: Utilize SQL queries to analyze the data and uncover trends indicative of fraudulent transactions.


## SQL TABLE CREATION QUERIES
```sql
DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS merchant;
DROP TABLE IF EXISTS merchant_category;
DROP TABLE IF EXISTS credit_card;
DROP TABLE IF EXISTS card_holder;

-- Table for card holders
CREATE TABLE card_holder (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Table for credit cards
CREATE TABLE credit_card (
    card VARCHAR(20) PRIMARY KEY,
    cardholder_id INT,
    FOREIGN KEY (cardholder_id) REFERENCES card_holder(id)
);

-- Table for merchant categories
CREATE TABLE merchant_category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Table for merchants
CREATE TABLE merchant (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    id_merchant_category INT,
    FOREIGN KEY (id_merchant_category) REFERENCES merchant_category(id)
);

-- Table for transactions
CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP NOT NULL,
    amount FLOAT NOT NULL,
    card VARCHAR(20),
    id_merchant INT,
    FOREIGN KEY (card) REFERENCES credit_card(card),
    FOREIGN KEY (id_merchant) REFERENCES merchant(id)
);

-- Table for merchants
CREATE TABLE merchant (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    id_merchant_category INT,
    FOREIGN KEY (id_merchant_category) REFERENCES merchant_category(id)
);

-- Table for transactions
CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    date TIMESTAMP NOT NULL,
    amount FLOAT NOT NULL,
    card VARCHAR(20),
    id_merchant INT,
    FOREIGN KEY (card) REFERENCES credit_card(card),
    FOREIGN KEY (id_merchant) REFERENCES merchant(id)
);

--How can you isolate (or group) the transactions of each cardholder?
-- To isolate or group the transactions, I will use a view to encapsulate the logic for counting the transactions less than $2.00 per cardholder
CREATE VIEW small_transactions_per_cardholder AS
SELECT ch.name AS cardholder_name, cc.card AS credit_card_number, COUNT(t.id) AS num_transactions_less_than_2
FROM card_holder ch
JOIN credit_card cc ON ch.id = cc.cardholder_id
JOIN transaction t ON cc.card = t.card
WHERE t.amount < 2.00
GROUP BY ch.name, cc.card;

--query the small transactions view to get the information
SELECT * FROM small_transactions_per_cardholder;

--top 100 highest transactions made between 7:00am and 9:00am
CREATE VIEW top_transactions_7_to_9 AS 
SELECT * 
FROM transaction 
WHERE date_part('hour', date) >= 7 AND date_part('hour', date) < 9 
ORDER BY amount 
DESC LIMIT 100;

--query the top_transactions_7_to_9 view to get the data
SELECT *
FROM top_transactions_7_to_9;

-- Top 5 merchant prone to hacking
CREATE VIEW merchants_prone_to_hacking AS
SELECT m.name AS merchant_name,
       COUNT(t.id) AS num_small_transactions
FROM merchant m
JOIN transaction t ON m.id = t.id_merchant
WHERE t.amount < 2.00
GROUP BY m.name
ORDER BY num_small_transactions DESC
LIMIT 5;

--Query for top 5 merchants prone to hacking
SELECT * FROM merchants_prone_to_hacking;


```

## Data Analysis
### Part 1
 ### Is there any evidence to suggest that a credit card has been hacked? Explain your rationale ?
   YES! The query for small_transactions_per_cardholder returns rows showing suspicious activities of multiple transactions less than $2.00
   
### What are the top 100 highest transactions made between 7:00 am and 9:00 am?
SELECT *
FROM top_transactions_7_to_9; 

| id   | date                 | amount | card              | id_merchant | rank |
|------|----------------------|--------|-------------------|-------------|------|
| 3163 | 2018-12-07 07:22:03  | 1894   | 4761049645711555811 | 9           | 1    |
| 2451 | 2018-03-05 08:26:08  | 1617   | 5570600642865857    | 4           | 2    |
| 2840 | 2018-03-06 07:18:09  | 1334   | 4319653513507       | 87          | 3    |
| 1442 | 2018-01-22 08:07:03  | 1131   | 5570600642865857    | 144         | 4    |
| 968  | 2018-09-26 08:48:40  | 1060   | 4761049645711555811 | 134         | 5    |
| 3205 | 2018-05-18 07:20:54  | 1048   | 4761049645711555811 | 102         | 6    |
| 4461 | 2018-06-29 08:56:47  | 1014   | 4319653513507       | 160         | 7    |
| 4546 | 2018-03-02 07:56:03  | 1009   | 5570600642865857    | 153         | 8    |
| 2614 | 2018-10-09 08:16:50  | 978    | 5570600642865857    | 98          | 9    |
| 1530 | 2018-08-23 07:05:10  | 968    | 4761049645711555811 | 154         | 10   |
| 3697 | 2018-06-15 07:03:10  | 961    | 5570600642865857    | 6           | 11   |
| 1956 | 2018-10-14 07:23:29  | 955    | 4761049645711555811 | 94          | 12   |
| 3574 | 2018-08-25 07:16:10  | 950    | 4319653513507       | 130         | 13   |
| 4665 | 2018-07-14 08:15:53  | 943    | 4761049645711555811 | 46          | 14   |
| 2003 | 2018-07-16 07:53:08  | 933    | 5570600642865857    | 150         | 15   |
| 4080 | 2018-06-21 07:53:33  | 922    | 4761049645711555811 | 2           | 16   |
| 4341 | 2018-07-06 08:07:29  | 909    | 4319653513507       | 69          | 17   |
| 3311 | 2018-01-07 07:53:45  | 889    | 4319653513507       | 158         | 18   |
| 2242 | 2018-02-19 07:12:26  | 871    | 5570600642865857    | 94          | 19   |
| 4924 | 2018-11-03 08:22:00  | 861    | 4319653513507       | 23          | 20   |
| 1010 | 2018-07-19 07:52:26  | 857    | 5570600642865857    | 81          | 21   |
| 3810 | 2018-02-26 08:40:29  | 853    | 4761049645711555811 | 38          | 22   |
| 1351 | 2018-05-28 07:46:38  | 848    | 4761049645711555811 | 22          | 23   |
| 2394 | 2018-05-12 07:46:01  | 839    | 4319653513507       | 77          | 24   |
| 4766 | 2018-10-11 07:56:23  | 834    | 4761049645711555811 | 25          | 25   |
| 4764 | 2018-08-20 07:53:39  | 829    | 4319653513507       | 157         | 26   |
| 1070 | 2018-03-29 07:41:47  | 822    | 5570600642865857    | 125         | 27   |
| 4691 | 2018-09-14 07:15:18  | 820    | 4761049645711555811 | 160         | 28   |
| 3006 | 2018-08-02 07:51:26  | 816    | 4319653513507       | 142         | 29   |
| 4567 | 2018-10-20 07:09:34  | 803    | 5570600642865857    | 58          | 30   |
| 4482 | 2018-04-19 07:51:15  | 800    | 4761049645711555811 | 151         | 31   |
| 4402 | 2018-04-22 08:37:41  | 796    | 5570600642865857    | 14          | 32   |
| 2247 | 2018-02-25 07:33:56  | 793    | 4761049645711555811 | 59          | 33   |
| 1291 | 2018-08-18 07:30:36  | 789    | 5570600642865857    | 63          | 34   |
| 3638 | 2018-11-09 07:35:54  | 781    | 4319653513507       | 151         | 35   |
| 4346 | 2018-07-07 08:11:54  | 778    | 4761049645711555811 | 115         | 36   |




### Do you see any anomalous transactions that could be fraudulent?
YES!. To identify anomalous transactions that could potentially be fraudulent, I would typically consider transactions that are repetitive and deviate from the typical spending pattern of the cardholder. I would flag repetitive transactions from card "4761049645711555811" as potential fraudulent activity given the amounts involved (1894, 1060 and 1017) and the short time period. I would also flag card "4319653513507"

### Is there a higher number of fraudulent transactions made during this time frame versus the rest of the day?
YES

### If you answered yes to the previous question, explain why you think there might be fraudulent transactions during this time frame.
Most fraudulent activities are automated, and early morning hours may offer less oversight. Cardholders may be less likely to notice or question small fraudulent transactions during busy morning routines, making them more susceptible to fraud during this time frame.

### What are the top 5 merchants prone to being hacked using small transactions?

| merchant_name                  | num_small_transactions |
|--------------------------------|------------------------|
| Wood-Ramirez                   | 7                      |
| Hood-Phillips                  | 6                      |
| Baker Inc                      | 6                      |
| Mcdaniel, Hines and Mcfarland | 5                      |
| Hamilton-Mcfarland             | 5                      |



