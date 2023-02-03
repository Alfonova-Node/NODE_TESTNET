#!/bin/bash

echo "================================================================================"
echo -e "\033[0;35m"
echo " :::       :::   :::::::::       :::           :::::::::      ::::::::::    ";
echo " ::: +   + :::   :::     ::::    :::          ::::    :::    :::       ::   ";
echo " :+: ++ ++ :+:   :+:     :+::+   ::+          +::      ::+   :+:            ";
echo " +:+  +:+  +:+   ++:      ++:+   +:+         :++       ++:   :+:+#######  ";
echo " +#+       +#+   +++      #+++   #++         +#+       +#+   +#+      ###   ";
echo " ###       ###   ###    #####    #########    ###     ###    ###      ###   ";
echo " ###       ###   ### ######      #########      #######       ##########   ";
echo -e "\e[0m"
echo "================================================================================="
PASSWORDKU=$PASSWORD
sleep 1
cd ~
rm -rf buyrolls.sh
sudo apt-get update
sudo apt-get install libssl-dev -y
rm -rf massa_TEST.17.2_release_linux.tar.gz
rm -rf buyrolls.sh
rm -rf /root/massa/massa-node/storage/peers.json

mv massa massaold
wget https://github.com/massalabs/massa/releases/download/TEST.18.0/massa_TEST.18.0_release_linux.tar.gz
tar xvzf massa_TEST.18.0_release_linux.tar.gz
clear
cd ~
cd $HOME/massa/massa-node/config/ && rm -rf node_privkey.key


cp $HOME/massaold/massa-node/config/config.toml $HOME/massa/massa-node/config/config.toml
cp $HOME/massaold/massa-node/config/node_privkey.key $HOME/massa/massa-node/config/node_privkey.key
cp $HOME/massaold/massa-client/wallet.dat $HOME/massa/massa-client/wallet.dat

cd $HOME
# cd massa/massa-node/base_config && rm -rf config.toml
# wget https://raw.githubusercontent.com/mdlog/testnet-mdlog/main/massa/config.toml


sudo tee /root/massa/massa-node/run.sh > /dev/null <<EOF
#!/bin/bash
cd ~/massa/massa-node/
./massa-node -p $PASSWORDKU |& tee logs.txt
EOF

sudo tee /etc/systemd/system/massad.service > /dev/null <<EOF
[Unit]
Description=Massa Node
After=network-online.target
[Service]
Environment="RUST_BACKTRACE=full"
User=$USER
ExecStart=/root/massa/massa-node/run.sh
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
EOF

chmod +x /root/massa/massa-node/run.sh
systemctl daemon-reload 
systemctl enable massad 
systemctl restart massad
sleep 60
clear
cd $HOME
wget -O buyrolls.sh https://raw.githubusercontent.com/mdlog/testnet-mdlog/main/massa/buyrolls.sh && chmod +x buyrolls.sh && screen -xR -S buyrolls ./buyrolls.sh
