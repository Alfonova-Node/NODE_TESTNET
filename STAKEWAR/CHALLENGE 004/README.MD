# Create Monitoring Node Status (Challenge 004)
In this section, you will create a monitoring node status to see the node version and so on.

1. Install jq
```
sudo apt install curl jq
```
Check your node version
```
curl -s http://127.0.0.1:3030/status | jq .version
```
- Check Delegators and Stake
```bash
near view xx.factory.shardnet.near get_accounts '{"from_index": 0, "limit": 10}' --accountId xx.shardnet.near
```
- Check Block Produced
```bash
curl -s -d '{"jsonrpc": "2.0", "method": "validators", "id": "dontcare", "params": [null]}' -H 'Content-Type: application/json' 127.0.0.1:3030 | jq  '.result.current_validators[] | select(.account_id | contains ("xx.factory.shardnet.near"))'
```
- Check Reason Validator Kicked
```bash
curl -s -d '{"jsonrpc": "2.0", "method": "validators", "id": "dontcare", "params": [null]}' -H 'Content-Type: application/json' 127.0.0.1:3030 | jq -c '.result.prev_epoch_kickout[] | select(.account_id | contains ("xx.factory.shardnet.near"))' | jq .reason
```
- Synchronization Check
Make sure the `syncing` status is `false` so that your validators don't miss blocks. If it's still `true` then your nodes are still not fully synchronized.
```bash
curl -s http://127.0.0.1:3030/status | jq .sync_info
```
