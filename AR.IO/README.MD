# CARA GARAP AR.IO
Pada kesempatan kali ini kita akan menggarap node ar.io dengan mudah

<p align="center">
  <img height="350" height="auto" src="https://pbs.twimg.com/profile_images/1572943803945738241/uzvOMcMb_400x400.jpg">
</p>

1. Persiapan 
>-  Menginstal dan membuat wallet pada https://chrome.google.com/webstore/detail/arconnect/einnioafmpimabjcddiinlhmijaionap
>-  Isi wallet teman teman minimal 0.02ar yang bisa teman teman depo dari binance
>-  Membeli domain TOP LEVEL contohnya .com/.dev/.xyz `JANGAN MENGGUNAKAN DOMAIN MY.ID KARENA SISTEM AKAN MENDETEKSI BAHWA ANDA HANYA MENGGUNAKAN SUBDOMAIN`

2. Instalasi Package
```
sudo apt update && sudo apt upgrade -y && sudo apt-get update && sudo apt install jq git certbot nginx sqlite3 build-essential -y && sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash && source ~/.bashrc && nvm install 16.15.1 && nvm use 16.15.1 && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && sudo apt-get update -y && sudo apt-get install yarn -y git clone https://github.com/ar-io/ar-io-node.git
```
3.  Membuka Port 
disini kita akan membuka port untuk mengizinkan koneksi tetapi jika anda pengguna digital ocean saya harap setelah anda membuka port anda wajib pergi ke panel digital ocean anda lalu masuk ke menu recovery lalu pilih launch recovery lalu open port 22 agar kalian dapat login lagi ke vps karena jika kita open port di digital ocean maka port 22 akan mati
```
sudo ufw allow sshl sudo ufw allow 80; sudo ufw allow 443; sudo ufw enable
```

4. Mengatur Domain
a. Setelah anda membeli domain tadi saya sarankan anda menyambungkanya ke https://dash.cloudflare.com/ dengan cara name servernya yang di ubah
b. Jika domain anda sudah di set ke cloudflare maka anda harus membuat DNS seperti gambar berikut ini :

![Screenshot_1](https://i.ibb.co/Xzr0494/photo-2023-09-12-14-23-24.jpg)


