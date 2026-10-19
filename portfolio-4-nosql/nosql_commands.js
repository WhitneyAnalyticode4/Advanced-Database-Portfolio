// Portfolio 4: NoSQL and Advanced Data Models (NairaPay)
// MongoDB Atlas, database: nairapay, collection: txn_logs

use nairapay

// 1. Insert 5 transaction log documents (note the different fields)
db.txn_logs.insertMany([
  { reference: 'TX1001', type: 'transfer', from_account: '1000000001', to_account: '1000000002',
    amount: 5000, status: 'success', device: { channel: 'mobile', os: 'Android' }, created_at: new Date() },
  { reference: 'TX1002', type: 'withdrawal', from_account: '1000000003',
    amount: 20000, status: 'success', atm: { id: 'ATM-LAG-014', location: 'Ikeja' }, created_at: new Date() },
  { reference: 'TX1003', type: 'transfer', from_account: '1000000004', to_account: '1000000001',
    amount: 90000, status: 'failed', failure_reason: 'insufficient funds', created_at: new Date() },
  { reference: 'TX1004', type: 'transfer', from_account: '1000000001', to_account: '1000000005',
    amount: 12000, status: 'success', device: { channel: 'web', os: 'Windows' }, created_at: new Date() },
  { reference: 'TX1005', type: 'deposit', to_account: '1000000002',
    amount: 50000, status: 'success', branch: { code: 'IKJ-01', teller: 'T-204' }, created_at: new Date() }
])

// 2. Find all failed transactions
db.txn_logs.find({ status: 'failed' })

// 3. Find one document (shows the nested device object)
db.txn_logs.findOne({ reference: 'TX1001' })

// 4. Total sent per account, biggest first (aggregation pipeline)
db.txn_logs.aggregate([
  { $match: { status: 'success', from_account: { $exists: true } } },
  { $group: { _id: '$from_account', total_sent: { $sum: '$amount' } } },
  { $sort: { total_sent: -1 } }
])

// 5. Create an index on reference and list the indexes
db.txn_logs.createIndex({ reference: 1 })
db.txn_logs.getIndexes()
