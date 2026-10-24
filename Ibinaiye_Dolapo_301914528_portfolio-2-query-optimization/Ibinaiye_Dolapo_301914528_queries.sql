-- Portfolio 2: Query Processing and Optimisation (NairaPay)

-- Q1: Statement for account 500 (all money in or out)
SELECT txn_id, reference, txn_type, amount, status, created_at
FROM transactions
WHERE from_account_id = 500 OR to_account_id = 500
ORDER BY created_at DESC;

-- Q2: Money moved each month (successful transactions only)
SELECT DATE_TRUNC('month', created_at) AS month, COUNT(*) AS num_txns, SUM(amount) AS total_value
FROM transactions
WHERE status = 'success'
GROUP BY 1
ORDER BY 1;

-- Q3: Top 10 customers by balance
SELECT c.full_name, a.account_number, a.balance
FROM accounts a
JOIN customers c ON c.customer_id = a.customer_id
ORDER BY a.balance DESC
LIMIT 10;

-- Q4: Number of transactions in each status
SELECT status, COUNT(*) FROM transactions GROUP BY status;

-- Q5: Customers who sent more than 5 million in total
SELECT c.full_name, SUM(t.amount) AS total_sent
FROM transactions t
JOIN accounts a ON a.account_id = t.from_account_id
JOIN customers c ON c.customer_id = a.customer_id
WHERE t.status = 'success'
GROUP BY c.full_name
HAVING SUM(t.amount) > 5000000
ORDER BY total_sent DESC;

-- Optimisation: measure BEFORE the index 
EXPLAIN ANALYZE
SELECT * FROM transactions WHERE from_account_id = 500 ORDER BY created_at DESC;

-- Create the index
CREATE INDEX idx_txn_from_created ON transactions (from_account_id, created_at DESC);
ANALYZE transactions;

-- Optimisation: measure AFTER the index 
EXPLAIN ANALYZE
SELECT * FROM transactions WHERE from_account_id = 500 ORDER BY created_at DESC;
