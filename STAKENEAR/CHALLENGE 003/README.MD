# Mounting Staking Pool (Challenge 003)
In this step you will create a validator that will run on shardnet.

1. Staking Pool Contract
```bash
near call factory.shardnet.near create_staking_pool '{"staking_pool_id": "nama_wallet", "owner_id": "xx.shardnet.near", "stake_public_key": "public_key_kamu", "reward_fee_fraction": {"numerator": 5, "denominator": 100}, "code_hash":"DD428g9eqLL8fWUxv8QSpVFzyHi1Qd16P8ephYCTmMSZ"}' --accountId="xx.shardnet.near" --amount=30 --gas=300000000000000
```
- `name_wallet` replace with your wallet name (example: tester01).
- `xx.shardnet.near` replace xx with your wallet name (same as above) and the same `accountId`.
- your `public_key` replace with your `wallet public_key` using the command below.

```bash
cat ~/.near/validator_key.json | jq .public_key
```
--amount=30 you can change the amount of your NEAR stake from 30 to whatever you want (because 30 is the minimum stake), 1 wallet has 500 NEAR but you better leave NEAR (the more the better) to pay the gas fee later. But to make sure how much NEAR you need, you can check the seat price [here](https://explorer.shardnet.near.org/nodes/validators)

2. If you have finished, then the results

![Screenshot 1](https://user-images.githubusercontent.com/35837931/180383828-272a660e-0a1a-4252-a5f4-880e3961e49f.png)

3. Check your validators whether they appear in the explorer or not.
https://explorer.shardnet.near.org/nodes/validators

## Useful Command
Don't forget to replace `xx` with your wallet name (example: `tester01`) and replace amount with the number you will input (example: `1` in NEAR form for stake or for unstake `100000000000000000000000000000000`this is in `yoctoNEAR` amount)

### Changing the commission
You can change your validator commission by a certain amount, the command below you will change it to 3% or change the number 3 in the `numerator` section: 3 as you wish.
```bash
near call xx.factory.shardnet.near update_reward_fee_fraction '{"reward_fee_fraction": {"numerator": 3, "denominator": 100}}' --accountId xx.shardnet.near --gas=300000000000000
```
### Deposit dan Stake NEAR
`amount_NEAR` replace with numbers only in NEAR form (example: `--amount 1`).
```bash
near call xx.factory.shardnet.near deposit_and_stake --amount jumlah_NEAR --accountId xx.shardnet.near --gas=300000000000000
```
### Unstake NEAR
`amount_yoctoNEAR` replace with numbers only in yoctoNEAR form (example: `'{"amount": "100000000000000000000000000000000"}'`).
> 1 NEAR = 1000000000000000000000000 yoctoNEAR

Run the following command to unstake:
```bash
near call xx.factory.shardnet.near unstake '{"amount": "jumlah_yoctoNEAR"}' --accountId xx.shardnet.near --gas=300000000000000
```
To unstake all NEARs run this command:
```bash
near call xx.factory.shardnet.near unstake_all --accountId xx.shardnet.near --gas=300000000000000
```
### Withdraw
Unstaking takes 2-3 epochs to be withdrawn to your wallet account.
Command to withdraw a certain amount in the form of `yoctoNEAR`:
```bash
near call xx.factory.shardnet.near withdraw '{"amount": "jumlah_yoctoNEAR"}' --accountId xx.shardnet.near --gas=300000000000000
```
Command to withdraw everything:
```bash
near call xx.factory.shardnet.near withdraw_all --accountId xx.shardnet.near --gas=300000000000000
```
### Ping
Ping is to update reports and update staking balances for your delegators. Pings must be reported every epoch to keep current rewards updated and you can do Challenges 006 to be able to ping for 5 minutes.
```bash
near call xx.factory.shardnet.near ping '{}' --accountId xx.shardnet.near --gas=300000000000000
```
Balances Total Balance Command :
```bash
near view xx.factory.shardnet.near get_account_total_balance '{"account_id": "xx.shardnet.near"}'
```
### Staked Balance
```bash
near view xx.factory.shardnet.near get_account_staked_balance '{"account_id": "xx.shardnet.near"}'
```
### Unstaked Balance
```bash
near view xx.factory.shardnet.near get_account_unstaked_balance '{"account_id": "xx.shardnet.near"}'
```
### Available for Withdrawal
You can only withdraw NEAR tokens from the contract if it is unlocked.
```bash
near view xx.factory.shardnet.near is_account_unstaked_balance_available '{"account_id": "xx.shardnet.near"}'
```
### Pause / Resume Staking
- Pause
```bash
near call xx.factory.shardnet.near pause_staking '{}' --accountId xx.shardnet.near
```
- Resume
```bash
near call xx.factory.shardnet.near resume_staking '{}' --accountId xx.shardnet.near
```
## Continue to Challenge 004


