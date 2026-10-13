CREATE TABLE customers (
  customer_id SERIAL PRIMARY KEY,
  full_name   VARCHAR(100) NOT NULL,
  email       VARCHAR(100) NOT NULL UNIQUE,
  phone       VARCHAR(20),
  created_at  TIMESTAMP DEFAULT NOW()
);

CREATE TABLE accounts (
  account_id     SERIAL PRIMARY KEY,
  customer_id    INT NOT NULL REFERENCES customers(customer_id),
  account_number CHAR(10) NOT NULL UNIQUE,
  account_type   VARCHAR(20) NOT NULL CHECK (account_type IN ('savings','current')),
  balance        NUMERIC(15,2) NOT NULL DEFAULT 0 CHECK (balance >= 0),
  status         VARCHAR(10) NOT NULL DEFAULT 'active',
  created_at     TIMESTAMP DEFAULT NOW()
);

CREATE TABLE transactions (
  txn_id          SERIAL PRIMARY KEY,
  reference       VARCHAR(30) NOT NULL UNIQUE,
  txn_type        VARCHAR(15) NOT NULL CHECK (txn_type IN ('deposit','withdrawal','transfer','reversal')),
  from_account_id INT REFERENCES accounts(account_id),
  to_account_id   INT REFERENCES accounts(account_id),
  amount          NUMERIC(15,2) NOT NULL CHECK (amount > 0),
  status          VARCHAR(10) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','success','failed','reversed')),
  created_at      TIMESTAMP DEFAULT NOW()
);
