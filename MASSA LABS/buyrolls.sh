#!/bin/bash

if [ ! $PASSWORD ]; then
read -p "Input Password Client Kamu: " PASSWORD
echo 'export PASSWORD='\"${PASSWORD}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
. $HOME/.bash_profile

echo -e "Password Client Kamu: \e[1m\e[32m${PASSWORD}\e[0m"
echo '================================================='
PASSWORDKU=$PASSWORD
sleep 1

rm -rf update-node.sh
declare -i int_balance
declare -i lc



while true
do

if [ ! -e $HOME/massa/massa-client/massa-client ]; then
  echo "Install Massa Binary";
fi
chmod +x $HOME/massa/massa-client/massa-client
cd $HOME/massa/massa-client/
wallet_temp=$(./massa-client wallet_info -p $PASSWORDKU | grep "Address" | awk '{ print $2 }')
wallet=${wallet_temp};
echo "Address is: "$wallet;
if [ ! "$wallet" ];then
   echo "Wallet not found. Please check again";
fi


cd $HOME/massa/massa-client
secret_keys=$(./massa-client wallet_info -p $PASSWORDKU | grep "Secret key" | awk '{ print $3 }')
cd $HOME/massa/massa-client && wallet_priv_key=$(./massa-client -p $PASSWORDKU node_add_staking_secret_keys $secret_keys )

cd $HOME/massa/massa-client
balance=$(./massa-client wallet_info -p $PASSWORDKU | grep -oP "Balance: final=\K\S+" | awk '{ print $1 }')
balances=${balance};
bal=${balances::-1};
echo "Balances is; "$bal;

int_balance=${bal%\.*};
if [ $int_balance = " " ]; then
        echo " Insufficient wallet"
elif [ $int_balance -gt "99" ]; then
        resp=$(./massa-client buy_rolls $wallet $(($int_balance/100)) 0 -p $PASSWORDKU )
        echo $resp
fi

printf "sleep"
         for((sec=0; sec<60; sec++))
         do
                printf "."
                sleep 1
         done
         printf "\n"
 done
