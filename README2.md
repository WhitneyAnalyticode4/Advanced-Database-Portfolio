Database Systems: Portfolio Documentation

Name: Dolapo Withney Ibinaiye | Matric number: 2026/A/MIT/0576    | Student ID: 301914528

GitHub repository: https://github.com/WhitneyAnalyticode4/Advanced-Database-Portfolio

1. Selected organisation

Organisation: NairaPay, a simulated digital bank in Nigeria. Nature of the system: a retail banking platform. Users: customers, bank tellers and auditors. Major data: customers, accounts, deposits, withdrawals, transfers and transaction logs. Key operations: transfer funds, reverse failed transactions, and audit account balances. This case study comes from the Bank / Fintech row of the course brief and is used in all five portfolios.

2. Portfolio 1: Database Design

I designed a relational schema with three tables: customers, accounts and transactions. Each table has a primary key. Accounts link to customers, and transactions link to accounts, through foreign keys. Constraints protect the data: UNIQUE on email and account number, CHECK that balances are never negative and amounts are above zero, and CHECK lists for account type, transaction type and status. I explained normalisation by starting from one flat table that repeated customer details on every row, described the update, insert and delete problems it causes, and split it through 1NF, 2NF and 3NF into the three tables.

![ER diagram](er-diagram.png)

3. Portfolio 2: Query Processing and Optimisation

I filled the database with generated test data: 1,000 customers, 1,000 accounts and 200,000 transactions. I wrote five business queries, including an account statement, monthly totals, top customers by balance, a count by status, and customers who sent large totals using joins and HAVING. I then measured one query with EXPLAIN ANALYZE. Before indexing, PostgreSQL used a sequential scan and took 132.261 ms. After I created an index on from_account_id and created_at, it used an index scan and took 2.561 ms, which is about 52 times faster. The trade-off is that indexes use extra storage and slow down inserts slightly.

![Before](before-index.png)

![After](after-index.png)

4. Portfolio 3: Transactions and Concurrency

I used two pgAdmin windows to act as two users. A transfer of 5,000 inside BEGIN and COMMIT changed both balances together (95000 and 105000). A transfer that tried to overdraw an account broke the CHECK rule, and ROLLBACK undid the whole transaction, including the earlier deduction, which shows atomicity. I then reproduced a lost update: both users read a balance of 95000, one withdrew 80,000 and the other withdrew 70,000 using the old value, and the final balance was 25000 instead of a refused request. Reading the row with SELECT ... FOR UPDATE fixed this: the second user waited for the first to commit, then saw the correct balance of 15000. I also explained the PostgreSQL isolation levels.

![Final balance](demo3-final.png)

5. Portfolio 4: NoSQL and Advanced Data Models

I modelled the NairaPay transaction log as documents in MongoDB, hosted on a free MongoDB Atlas cluster. Balances and transfers stay in PostgreSQL because they need strict rules. I inserted five log documents whose fields differ (device, atm, failure_reason and branch), which would need many empty columns in SQL. I ran a find query for failed transactions, a query showing a nested device object, an aggregation pipeline that totals the amount sent per account (account 1000000003 sent 20000 and account 1000000001 sent 17000), and I created an index on the reference field. NoSQL suits this data because it is flexible, contains nested details, and is written constantly.

![Aggregate](p4-6-aggregate.png)

6. Portfolio 5: Distributed and Cloud Database

My Atlas cluster runs on Amazon Web Services in Cape Town (af-south-1), MongoDB version 8.0.34. The Metrics tab shows a replica set of three servers: one primary and two secondaries, each holding a copy of the data. This gives high availability, because the secondaries can take over if the primary fails, and it protects the data. I did not trigger a failure, so failover is described and not tested. The free tier cannot be sharded, so sharding is a design discussion: I would shard the log collection on a hashed account field to spread the load and avoid a hot spot. For money, NairaPay should choose consistency over availability, so balances stay in PostgreSQL with strict transactions. I also listed cloud benefits and risks, including data location rules, since my cluster is stored outside Nigeria.

![The three nodes](p5-2-nodes.png)

7. Individual technical reflection

•	Design choices: I chose the Bank / Fintech case study because it needs everything this course covers: strict rules for money, transactions that must succeed or fail as a whole, and a large log of events. I used the same simulated bank, NairaPay, in all five portfolios. I kept balances and transfers in PostgreSQL because they need constraints, transactions and locking, for example a balance can never be negative. I put the transaction log in MongoDB because the log entries have different fields (device, ATM, branch, failure reason) and are written all the time, which fits flexible documents better than fixed tables.

•	Challenges: My first challenge was in Portfolio 3. After I caused an error on purpose inside a transaction, PostgreSQL kept refusing every command and said the current transaction was aborted. I learned that I had to run ROLLBACK to end the transaction before continuing, and that in pgAdmin I should highlight and run one line at a time. The two-window concurrency demos also needed the lines in exactly the right order.

•	The second challenge was connecting to MongoDB Atlas. At first, Atlas blocked my connection because my IP address was not on the Network Access list, and later Compass kept failing to connect. I added my IP address and checked my connection string, but because Compass still did not connect reliably, I ran the operations in the Atlas Data Explorer in the browser and kept the equivalent mongosh commands in a file.

•	The third challenge was GitHub. One README did not format because the file name had a mistake (a trailing dot, and another was named Read.me), and at first some changes did not commit. I fixed the names and learned to commit directly to the main branch.

•	Lessons learned: I learned that an index can make a big difference: one query went from 132.261 ms to 2.561 ms, about 52 times faster, although indexes cost storage and slow inserts slightly. Portfolio 3 taught me that two users can leave an account with a wrong balance even when each statement looks correct, and that locking with FOR UPDATE fixes it by making the second user wait. I also learned that NoSQL does not replace SQL, each suits different parts of a bank. Replication keeps the data on three servers so one failure does not stop the system, and for money a bank should choose consistency over availability. Sharding could only be described, because the free tier cannot do it. 

8. References

•	PostgreSQL Global Development Group. PostgreSQL documentation. postgresql.org/docs

•	MongoDB, Inc. MongoDB Atlas and MongoDB Manual documentation. mongodb.com/docs

9. AI-use declaration

I used Claude, an AI assistant made by Anthropic, as a learning aid during this assessment. It explained concepts, suggested SQL and MongoDB commands, and helped me draft README files and this document. I ran all commands myself on my own PostgreSQL installation and MongoDB Atlas cluster, took all screenshots myself, and checked the results. 
