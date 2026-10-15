-- Portfolio 3: Transactions and Concurrency (NairaPay)

-- Reset
UPDATE accounts SET balance = 100000 WHERE account_id IN (1, 2);
DELETE FROM transactions WHERE reference = 'TXDEMO1';

-- Demo 1: successful transfer (COMMIT)
BEGIN;
UPDATE accounts SET balance = balance - 5000 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 5000 WHERE account_id = 2;
INSERT INTO transactions (reference, txn_type, from_account_id, to_account_id, amount, status)
VALUES ('TXDEMO1', 'transfer', 1, 2, 5000, 'success');
COMMIT;
SELECT account_id, balance FROM accounts WHERE account_id IN (1, 2);

-- Demo 2: failed transfer (ROLLBACK)
BEGIN;
UPDATE accounts SET balance = balance - 5000 WHERE account_id = 1;
UPDATE accounts SET balance = balance - 99999999 WHERE account_id = 1;  -- fails: CHECK (balance >= 0)
ROLLBACK;
SELECT balance FROM accounts WHERE account_id = 1;

-- Demo 3: lost update (two windows, no locking)
UPDATE accounts SET balance = 95000 WHERE account_id = 1;
-- Window A:
BEGIN;
SELECT balance FROM accounts WHERE account_id = 1;
-- Window B:
BEGIN;
SELECT balance FROM accounts WHERE account_id = 1;
-- Window A:
UPDATE accounts SET balance = 95000 - 80000 WHERE account_id = 1;
COMMIT;
-- Window B:
UPDATE accounts SET balance = 95000 - 70000 WHERE account_id = 1;
COMMIT;
SELECT balance FROM accounts WHERE account_id = 1;  -- 25000 (wrong)

-- Demo 4: the fix (FOR UPDATE)
UPDATE accounts SET balance = 95000 WHERE account_id = 1;
-- Window A:
BEGIN;
SELECT balance FROM accounts WHERE account_id = 1 FOR UPDATE;
UPDATE accounts SET balance = balance - 80000 WHERE account_id = 1;
-- Window B (waits until A commits):
BEGIN;
SELECT balance FROM accounts WHERE account_id = 1 FOR UPDATE;
-- Window A:
COMMIT;
-- Window B now sees 15000:
ROLLBACK;
