#!/bin/bash
clear
merah="\e[31m"
kuning="\e[33m"
hijau="\e[32m"
biru="\e[34m"
UL="\e[4m"
bold="\e[1m"
italic="\e[3m"
reset="\e[m"
# logo
curl -s https://raw.githubusercontent.com/Agus1224/NODE_TESTNET/main/logo_ALFONOVA | bash
sleep 2
# Env Vars
cd $HOME
source .bash_profile 2> /dev/null
invalid_input=""$bold""$merah"Invalid input "$REPLY". Tolong pilih yes atau no\n"$reset""
invalid_format=""$bold""$merah"Format salah$reset\n"
format=""$bold""$UL""$hijau""
continue=""$hijau""$bold"Tekan enter untuk melanjutkan"$reset""
bline="======================================================================="
script_config='--max-clients 100 \\\n --sync-fetch-span 1 \\'
#  \\\n --p2p-peer-address 135.181.133.169:9010 \\\n --p2p-peer-address 193.111.198.52:9010 \\\n --p2p-peer-address 185.144.99.30:9010 \\\n --p2p-peer-address 192.46.226.189:9010 \\\n --p2p-peer-address 144.91.99.67:9010 \\\n --p2p-peer-address 167.235.3.147:9010 \\\n --p2p-peer-address  45.84.138.118:9010 \\\n --p2p-peer-address 185.249.225.183:9010 \\\n --p2p-peer-address 38.242.235.150:9010 \\\n --p2p-peer-address  161.97.153.16:9010:9010 \\\n --p2p-peer-address   45.84.138.209:9010 \\\n --p2p-peer-address  38.242.248.157:9010 \\\n --p2p-peer-address 45.88.188.199:9010 \\\n --p2p-peer-address 5.189.138.167:9010 \\\n --p2p-peer-address 38.242.234.139:9010 \\\n --p2p-peer-address 86.48.0.180:9010 \\\n --p2p-peer-address 185.169.252.86:9010 \\\n --p2p-peer-address 38.242.130.28:9010 \\\n --p2p-peer-address 95.217.134.209:9010 \\\n --p2p-peer-address 78.46.123.82:9010 \\\n --p2p-peer-address 161.97.153.16:9010 \\\n --p2p-peer-address 38.242.154.67:9010 \\\n --p2p-peer-address 45.10.154.235:9010 \\\n --p2p-peer-address 45.84.138.8:9010 \\\n --p2p-peer-address 45.84.138.118:9010 \\\n --p2p-peer-address 38.242.248.157:9010 \\\n --p2p-peer-address 45.84.138.209:9010 \\\n --p2p-peer-address 95.217.236.223:9010 \\\n --p2p-peer-address 86.48.2.195:9010 \\\n --p2p-peer-address 135.181.254.255:9010 \\\n --p2p-peer-address 5.161.118.114:9010 \\\n --p2p-peer-address 78.47.159.172:9010 \\\n --p2p-peer-address 45.10.154.239:9010 \\\n --p2p-peer-address 45.84.138.9:9010 \\\n --p2p-peer-address 194.163.172.119:9010 \\\n --p2p-peer-address 45.84.138.119:9010 \\\n --p2p-peer-address 45.84.138.153:9010 \\\n --p2p-peer-address 130.185.118.73:9010 \\\n --p2p-peer-address 45.84.138.247:9010 \\\n --p2p-peer-address 80.65.211.208:9010 \\\n --p2p-peer-address 149.102.140.38:9010 \\\n --p2p-peer-address 38.242.149.97:9010 \\\n --p2p-peer-address 38.242.156.49:9010 \\\n --p2p-peer-address 38.242.159.125:9010 \\\n --p2p-peer-address 74.208.142.87:9010 \\\n --p2p-peer-address 38.242.235.150:9010 \\\n --p2p-peer-address 10.182.0.15:9010 \\\n --p2p-peer-address 185.249.225.183:9010 \\\n --p2p-peer-address 194.163.162.47:9010 \\\n --p2p-peer-address 193.46.243.16:9010 \\\n --p2p-peer-address 38.242.159.140:9010 \\\n --p2p-peer-address 161.97.169.27:9010 \\\n --p2p-peer-address 38.242.219.100:9010 \\\n --p2p-peer-address bis.blockchain-servers.world:9010 \\\n --p2p-peer-address sys.blockchain-servers.world:9010 \\\n --p2p-peer-address 193.111.198.52 \\\n --p2p-peer-address 62.210.245.223 \\\n --p2p-peer-address 185.144.99.30 \\\n --p2p-peer-address 38.242.153.15 \\\n --p2p-peer-address 192.46.226.189 \\\n --p2p-peer-address 194.5.152.187 \\\n --p2p-peer-address 5.189.138.167:9010 \\\n --p2p-peer-address 38.242.234.139:9010 \\\n --p2p-peer-address 86.48.0.180:9010 \\\n --p2p-peer-address 185.169.252.86:9010 \\\n --p2p-peer-address 38.242.130.28:9010 \\\n --p2p-peer-address 95.217.134.209:9010 \\\n --p2p-peer-address 78.46.123.82:9010 \\\n --p2p-peer-address 161.97.153.16:9010 \\\n --p2p-peer-address 38.242.154.67:9010 \\\n --p2p-peer-address 45.10.154.235:9010 \\\n --p2p-peer-address 45.84.138.8:9010 \\\n --p2p-peer-address 45.84.138.118:9010 \\\n --p2p-peer-address 38.242.248.157:9010 \\\n --p2p-peer-address 45.84.138.209:9010 \\\n --p2p-peer-address 95.217.236.223:9010 \\\n --p2p-peer-address 86.48.2.195:9010 \\\n --p2p-peer-address 135.181.254.255:9010 \\\n --p2p-peer-address 5.161.118.114:9010 \\\n --p2p-peer-address 78.47.159.172:9010 \\\n --p2p-peer-address 45.10.154.239:9010 \\\n --p2p-peer-address 45.84.138.9:9010 \\\n --p2p-peer-address 194.163.172.119:9010 \\\n --p2p-peer-address 45.84.138.119:9010 \\\n --p2p-peer-address 45.84.138.153:9010 \\\n --p2p-peer-address 130.185.118.73:9010 \\\n --p2p-peer-address 45.84.138.247:9010 \\\n --p2p-peer-address 80.65.211.208:9010 \\\n --p2p-peer-address 149.102.140.38:9010 \\\n --p2p-peer-address 38.242.149.97:9010 \\\n --p2p-peer-address 38.242.156.49:9010 \\\n --p2p-peer-address 38.242.159.125:9010 \\\n --p2p-peer-address 20.213.8.11:9010 \\\n --p2p-peer-address 74.208.142.87:9010 \\\n --p2p-peer-address 38.242.235.150:9010 \\\n --p2p-peer-address 10.182.0.15:9010 \\\n --p2p-peer-address 185.249.225.183:9010 \\\n --p2p-peer-address 194.163.162.47:9010 \\\n --p2p-peer-address 193.46.243.16:9010 \\'

if ! [[ $(type nodine 2> /dev/null) ]]; then
    echo -e 'export PATH="$PATH":"$HOME"/inery-node/inery/bin' >> $HOME/.bash_profile
fi

if [[ ! $inerylog ]]; then
    echo -e 'export inerylog="$HOME"/inery-node/inery.setup/master.node/blockchain/nodine.log' >> $HOME/.bash_profile
fi
source .bash_profile

# Function set_account_name

set_account_name(){

accname=""$bold""$hijau"account name"$reset""
accID="Masukan $accname: $reset"
while true; do
echo "$bline"
read -p "$(printf "$accID""$reset")" name
echo -e "$bline\n"
    if [[ ! "$name" =~ ^[a-z1-5]{1,12}[.]{0,1}[a-z1-5]{1,12}$ ||  ${#name} -gt 12 ]];then
        echo -e ""$name ""$invalid_format""$bold""$merah"Name can have maxiumum of 12 charachters ASCII lowercase a-z, 1-5 and dot character "." but dot can't be at the end of string\n"$reset""
	accID="Tolong masukan yang benar $accname: "
    else
	while true; do
        echo -e -n "Apakah $accname "$format""$name""$reset" sudah benar? [Y/n]"
        read yn
        case $yn in
            [Yy]* ) printf "\n"; ACC=true; break;;
            [Nn]* ) printf "\n"; ACC=false; break;;
            * ) echo -e "$invalid_input"; echo -e "$bline\n";;
        esac
        done
        if [[ $ACC = true ]]; then
            echo -e "export IneryAccname="$name"" >> $HOME/.bash_profile
            source $HOME/.bash_profile
            break
        else
            accID="Tolong masukan $accname lagi: "
        fi
    fi
done

}

# funtion Set pubkey

set_pubkey(){

pubkeyname="$bold""$hijau"public-key"$reset"
publickey="Masukan "$pubkeyname": $reset"
while true; do
echo $bline
read -p "$(printf "$publickey""$reset")" pubkey
echo -e "$bline\n"
    if [[ ! $pubkey =~ ^[INE]{1}[a-zA-Z1-9]{52}$ ]]; then
        echo -e "$bold$pubkeyname $pubkey" "$invalid_format"
        publickey="Tolong masukan yang benar $pubkeyname: $reset"
    else
	while true; do
        echo -e -n "Apakah $pubkeyname "$format""$pubkey"$reset sudah benar? [Y/n]"
        read yn
        case $yn in
            [Yy]* ) printf "\n"; PUB=true; break;;
            [Nn]* ) printf "\n"; PUB=false; break;;
            * ) echo -e "$invalid_input"; echo -e "$bline\n";;
        esac
        done
        if [ $PUB = true ]; then
            echo -e "export IneryPubkey="$pubkey"" >> $HOME/.bash_profile
            source $HOME/.bash_profile
	    break
        else
	    publickey="Masukan $pubkeyname lagi: "
        fi
    fi
done

}

# Funtion Set privkey

set_privkey(){

privkeyname="$bold""$hijau"private-key"$reset"
privatekey="Masukan"$hijau" $privkeyname: "
while true; do
echo -e "$bline"
read -p "$(printf "$privatekey""$reset")" privkey
echo -e "$bline\n"
    if [[ ! $privkey =~ ^[5]{1}[a-zA-Z1-9]{50}$ ]]; then
        echo -e "$bold$privkeyname $privkey" "$invalid_format"
        privatekey="Tolong masukan yang benar $privkeyname: $reset"
    else
	while true; do
        echo -e -n "Apakah $privkeyname "$format""$privkey"$reset sudah benar? [Y/n]"
        read yn
        case $yn in
            [Yy]* ) printf "\n"; PRIV=true; break;;
            [Nn]* ) printf "\n"; PRIV=false; break;;
            * ) echo -e "$invalid_input"; echo -e "$bline\n";;
        esac
        done
        if [[ $PRIV = true ]]; then
            break
	else
	    privatekey="Masukan $privkeyname lagi: "
        fi
    fi
done

}

set_peers(){

default_ip=$(hostname -i)
ipaddress="$bold""$hijau"ip-address"$reset"
enter_ip="Masukan public "$hijau" $ipaddress: "
while true; do
echo -e "$bline\n"
echo -e "$bold""$kuning"INFO: "$reset"Your IP in this machine is: "$bold""$hijau""$default_ip$reset\n"
echo -e "$bline"
read -p "$(printf "$enter_ip""$reset")" address
echo -e "$bline\n"
    if [[ ! $address =~ ^[0-9]{1,3}[.]{1}[0-9]{1,3}[.]{1}[0-9]{1,3}[.]{1}[0-9]{1,3}$ ]]; then
        echo -e "$bold$ipaddress $address" "$invalid_format"
        enter_ip="Tolong masukan yang benar public $ipaddress: $reset"
    else
	while true; do
        echo -e -n "Apakah $ipaddress "$format""$address"$reset sudah benar? [Y/n]"
        read yn
        case $yn in
            [Yy]* ) printf "\n"; ADDR=true; break;;
            [Nn]* ) printf "\n"; ADDR=false; break;;
            * ) echo -e "$invalid_input"; echo -e "$bline\n";;
        esac
        done
        if [[ $ADDR = true ]]; then
            break
	else
	    enter_ip="Masukan public $ipaddress lagi: "
        fi
    fi
done

}
# Import wallet

import_wallet(){
    rm -rf $HOME/inery-wallet
    cd; cline wallet create -n $name --file $HOME/$name.txt
    cline wallet import -n $name --private-key $privkey
}

# reg_producer

reg_producer(){
    cline wallet unlock -n $IneryAccname --password $(cat $HOME/$IneryAccname.txt)
    cline system regproducer $IneryAccname $IneryPubkey 0.0.0.0:9010
    echo -e ""$kuning""$bold"Reg producer success $reset"
    sleep 0.5
    cline system makeprod approve $IneryAccname $IneryAccname
    echo -e ""$kuning""$bold"Approve producer success $reset"
    sleep 0.5
}

# Set account

install_master_node(){
echo -e "$bold$hijau 1. Set account... $reset"
sleep 1

# S3t account
set_account_name
set_pubkey
set_privkey
set_peers

# Print account setting

echo -e "\n$bline"
echo -e "\t\t\tMaster-node configuration$reset"
echo -e "$bline"
echo -e "Your $accname is: $bold$hijau$name$reset"
echo -e "Your $pubkeyname is: $bold$hijau$pubkey$reset"
echo -e "Your $privkeyname is: $bold$hijau$privkey$reset"
echo -e "Your peers is: $bold$hijau$address:9010$reset"
echo -e "$bline\n"
sleep 2
# Update upgrade

echo -e "$bold$hijau 2. Updating packages... $reset"
sleep 1
sudo apt update && sudo apt upgrade -y

# Install dep

echo -e "$bold$hijau 3. Installing dependencies... $reset"
sleep 1
sudo apt install -y make bzip2 automake libbz2-dev libssl-dev doxygen graphviz libgmp3-dev \
autotools-dev libicu-dev python2.7 python2.7-dev python3 python3-dev \
autoconf libtool curl zlib1g-dev sudo ruby libusb-1.0-0-dev \
libcurl4-gnutls-dev pkg-config patch llvm-7-dev clang-7 vim-common jq libncurses5 ccze git screen

echo -e "$bold$hijau 4. Installing node... $reset"
sleep 1

# Clone repo

cd $HOME
pnodine=$(pgrep nodine)
if [[ $pnodine ]]; then
    pkill -9 nodine
fi
rm -rf inery-*
git clone https://github.com/inery-blockchain/inery-node

# Set config

peers="$address:9010"
sed -i "s/accountName/$name/g;s/publicKey/$pubkey/g;s/privateKey/$privkey/g;s/IP:9010/$peers/g" $HOME/inery-node/inery.setup/tools/config.json
cd ~/inery-node/inery.setup/tools/scripts/
script=("start.sh" "genesis_start.sh" "hard_replay.sh")
echo -e $script_config | tee -a ${script[@]} > /dev/null
echo -e "$bold$hijau 5. Running master node... $reset"
sleep 1
run_master
# create wallet

echo -e "$bold$hijau 6. Import wallet to local machine... $reset"
sleep 1
import_wallet

echo -e "$bold$hijau 7. Enable firewall... $reset"
sleep 1

# Enable firewall

sudo ufw allow 8888,9010/tcp
sudo ufw allow ssh
sudo ufw limit ssh

# Print

echo -e "\n========================$bold$biru SETUP FINISHED$reset ============================"
echo -e "Source vars environment:$bold$hijau source $HOME/.bash_profile $reset"
echo -e "Check your account name env vars:$bold$hijau echo \$IneryAccname $reset"
echo -e "Check your public-key env vars:$bold$hijau echo \$IneryPubkey $reset"
echo -e "Your wallet password save to:$bold$hijau cat $HOME/\$IneryAccname.txt $reset"
echo -e "Check logs with command:$bold$hijau tail -f \$inerylog | ccze -A $reset"
echo -e "========================$bold$biru SETUP FINISHED$reset ============================\n"
source $HOME/.bash_profile
sleep 2
}

run_master(){
chmod 777 $HOME/inery-node/inery.setup/ine.py
cd $HOME/inery-node/inery.setup
setsid ./ine.py --master >/dev/null 2>&1 &
}

while true; do
# logo

curl -s https://raw.githubusercontent.com/jambulmerah/guide-testnet/main/script/logo.sh | bash

# Menu

PS3='Select an action: '
options=(
"Install master node"
"Check Log"
"Reg/approve as producer TASK I"
"Create test token TASK II"
"Delete and uninstall node"
"Exit"
)
select opt in "${options[@]}"
do
case $opt in

"Install master node") # install Node
clear
install_master_node
sleep 1
clear
break;;

"Check Log") # Checklogs
clear
tail -f $inerylog | ccze -A
clear
continue;;

"Reg/approve as producer TASK I") # Reg as producer
clear
cd $HOME/inery-node/inery.setup/master.node/
./start.sh
if [[ $IneryAccname && $IneryPubkey ]]; then
        reg_producer
	echo -e ""$bold""$kuning"\nSuccessfull reg as producer"
	sleep 2
else
        echo -e ""$bold""$merah"No wallet in local machine found"
        echo -e ""$bold""$kuning"First create wallet and set as env vars"
        set_account_name
        set_pubkey
        set_privkey
	import_wallet
	reg_producer
	echo -e ""$bold""$kuning"\nSuccessfull reg as producer"
	sleep 2
fi
echo -e -n $continue
read
clear
break;;

"Create test token TASK II") # Create test token
clear
create_test_token(){

    cd $HOME
    rm -f token.wasm token.abi
    cline get code inery.token -c token.wasm -a token.abi --wasm
    if [[ -f /tmp/acclist ]]; then
        rm -rf /tmp/acclist > /dev/null
    fi
    echo -e "inery\ninery.token\njambul.inery" >/tmp/acclist
    tail -n 10000 $inerylog | grep "signed by" | awk '{printf "\n"$15}' | tail -17 >> /tmp/acclist
    mapfile -t acc_list </tmp/acclist
    cline wallet unlock -n $IneryAccname --password $(cat $IneryAccname.txt)
    cline set code $IneryAccname token.wasm
    echo -e ""$kuning""$bold"Set code success$reset"
    sleep 0.5
    cline set abi $IneryAccname token.abi
    echo -e ""$kuning""$bold"Set abi success$reset"
    create_data=\''["account", "30000.000 TKN", "creating my first tokens"]'\'
    issue_data=\''["account", "1000.000 TKN", "issuong 1000 TKN in circulating supply"]'\'
    transfer_data=\''["account", "test22", "1.000 TKN", "Here you go 1 TKN from account 😁"]'\'
    echo
    symbol_name=""$kuning""$bold"Set your token symbol: $reset"
    while read -p "$(printf "$symbol_name")" symbol; do
        if [[ ! $symbol =~ ^[A-Z]{1,7}$ ]]; then
            echo -e ""$kuning"Symbol only with 1-7 UPPERCASE"
            continue
        else
    create_token_data=$(echo -n $create_data | sed "s/account/$IneryAccname/g;s/TKN/$symbol/g")
    issue_token_data=$(echo -n $issue_data | sed "s/account/$IneryAccname/g;s/TKN/$symbol/g")
            tee /tmp/createtoken.sh >/dev/null <<EOF
#!/bin/bash
cline push action inery.token create $(echo -n $create_token_data) -p $IneryAccname
printf "\n$kuning$bold successfull create token symbol $symbol$reset\n"
sleep 2
cline push action inery.token issue $(echo -n $issue_token_data) -p $IneryAccname
echo -e "\n$kuning$bold successfull issuing token$reset\n"
sleep 2
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[0]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[1]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[2]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[3]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[4]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[5]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[6]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[7]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[8]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[9]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[10]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[11]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[12]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[13]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[14]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[15]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[16]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[17]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[18]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
cline push action inery.token transfer $(echo -n $transfer_data | sed "s/account/$IneryAccname/g;s/test22/${acc_list[19]}/g;s/TKN/$symbol/g") -p $IneryAccname
sleep 0.5
EOF
bash /tmp/createtoken.sh
            echo -e "Token succesfully transfered to ${#acc_list[*]} account"
            for list in ${!acc_list[*]}; do
	    printf "%4d: %s\n" $list ${acc_list[$list]}
	    done
            break
        fi
    done
}

cd $HOME
if [[ $IneryAccname && $IneryPubkey ]]; then
    create_test_token
    sleep 2
else
    echo -e ""$bold""$merah"No wallet in local machine found"$reset""
    echo -e ""$bold""$kuning"First create wallet and set as env vars"$reset""
    set_account_name
    set_pubkey
    set_privkey
    import_wallet
    create_test_token
    sleep 2
fi
echo -e -n $continue
read
clear
break;;

"Exit") clear; echo -e "$biru\t GOOD BY👋$reset"; sleep 1; exit;;

"Delete and uninstall node") # Full delete and uninstall
clear
cd ~/inery-node/inery.setup/master.node
./stop.sh
pnodine=$(pgrep nodine)
if [[ $pnodine ]]; then
    pkill -9 nodine
fi
./clean.sh
rm -rf $HOME/inery-*
rm -rf $HOME/$IneryAccname.txt
echo -e ""$bold""$kuning"Successfull stop and uninstall full node"$reset""
sleep 1
break;;

*) echo -e ""$bold""$merah"invalid option $REPLY $reset";;

esac
done
done
