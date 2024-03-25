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

