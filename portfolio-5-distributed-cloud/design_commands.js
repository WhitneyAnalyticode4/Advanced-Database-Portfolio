// Portfolio 5: Distributed and Cloud Database (NairaPay)
// DESIGN NOTES ONLY. These commands were NOT run: the Atlas Free cluster cannot be sharded.

// 1. Replication: stronger write safety
// Wait until most replica set members have the write before confirming it to the app
db.txn_logs.insertOne(
  { reference: 'TX2001', type: 'transfer', amount: 5000, status: 'success' },
  { writeConcern: { w: 'majority' } }
)

// 2. Sharding (needs a paid sharded cluster)
sh.enableSharding('nairapay')
sh.shardCollection('nairapay.txn_logs', { from_account: 'hashed' })
