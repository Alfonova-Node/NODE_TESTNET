# Make an Automatic Ping Every 2 Hours
In this section you will create an automated transaction to ping your validators.

1. Create a Folder for Logs
```bash
mkdir $HOME/nearcore/logs
```
2. Create a ping.sh file
```bash
nano $HOME/nearcore/scripts/ping.sh
```
3. Then fill the file with the code below
replace `xx` with your wallet name (example: `tester01`) without `.shardnet.near` or `.factory.shardnet.near`.
```bash
#!/bin/sh
# Ping call to renew Proposal added to crontab

export NEAR_ENV=shardnet
export LOGS=$HOME/nearcore/logs
export POOLID="xx"
export ACCOUNTID="xx"

echo "---" >> $LOGS/all.log
date >> $LOGS/all.log
near call $POOLID.factory.shardnet.near ping '{}' --accountId $ACCOUNTID.shardnet.near --gas=30000000000000 >> $LOGS/all.log
near proposals | grep $POOLID >> $LOGS/all.log
near validators current | grep $POOLID >> $LOGS/all.log
near validators next | grep $POOLID >> $LOGS/all.log
```
4. Then open crontab
```
crontab -e
```
5. Then select number 1 to edit the file with `nano`
6. Enter the code below
```bash
0 */2 * * * sh $HOME/nearcore/scripts/ping.sh
```
Then press `CTRL + O` and `CTRL + X`
7. Check whether your crontab is running or not.
```
crontab -l
```
[Screenshot 1](https://user-images.githubusercontent.com/35837931/181238951-4ead8ebf-50ef-4ac2-8bc0-154b7d8c2ecc.png)

8. Check Log (you have to wait 2 hours for it to appear)
```
cat $HOME/nearcore/logs/all.log
```
`(Optional)` or you can run the script first in the following way.
```bash
sh $HOME/nearcore/scripts/ping.sh
```
Check Log
