-- isolate (or group) the transactions
CREATE VIEW cardholder_transactions AS
SELECT ch.id AS cardholder_id, c.card AS credit_card, t.id AS transaction_id, t.amount
FROM card_holder ch
JOIN credit_card c ON ch.id = c.cardholder_id
JOIN transaction t ON c.card = t.card;

--transactions less than $2.00 per cardholder
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

-- Create a view to represent counts of fraudulent transactions (less than 2.00USD) between 7am-9am and across time frames
CREATE VIEW fraudulent_transactions_counts AS
SELECT
    '7:00 am to 9:00 am' AS time_frame,
    COUNT(*) AS count
FROM
    transaction
WHERE
    date_part('hour', date) >= 7 
    AND date_part('hour', date) < 9
    AND amount < 2
UNION
SELECT
    'Rest of the day' AS time_frame,
    COUNT(*) AS count
FROM
    transaction
WHERE
    (date_part('hour', date) < 7 OR date_part('hour', date) >= 9)
    AND amount < 2;

SELECT * FROM fraudulent_transactions_counts

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
