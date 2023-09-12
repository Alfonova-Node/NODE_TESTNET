
<p align="center">
  <img height="350" height="auto" src="https://pbs.twimg.com/profile_images/1572943803945738241/uzvOMcMb_400x400.jpg">
</p>

# Persiapan 
>-  Menginstal dan membuat wallet pada https://chrome.google.com/webstore/detail/arconnect/einnioafmpimabjcddiinlhmijaionap
>-  Isi wallet teman teman minimal 0.02ar yang bisa teman teman depo dari binance
>-  Membeli domain TOP LEVEL contohnya .com/.dev/.xyz `JANGAN MENGGUNAKAN DOMAIN MY.ID KARENA SISTEM AKAN MENDETEKSI BAHWA ANDA HANYA MENGGUNAKAN SUBDOMAIN`

# Instalasi Package
```
sudo apt update && sudo apt upgrade -y && sudo apt-get update && sudo apt install jq git certbot nginx sqlite3 build-essential -y && sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash && source ~/.bashrc && nvm install 16.15.1 && nvm use 16.15.1 && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && sudo apt-get update -y && sudo apt-get install yarn -y git clone https://github.com/ar-io/ar-io-node.git
```
# Membuka Port 
disini kita akan membuka port untuk mengizinkan koneksi tetapi jika anda pengguna digital ocean saya harap setelah anda membuka port anda wajib pergi ke panel digital ocean anda lalu masuk ke menu recovery lalu pilih launch recovery lalu open port 22 agar kalian dapat login lagi ke vps karena jika kita open port di digital ocean maka port 22 akan mati
```
sudo ufw allow sshl sudo ufw allow 80; sudo ufw allow 443; sudo ufw enable
```

4. Mengatur Domain
a. Setelah anda membeli domain tadi saya sarankan anda menyambungkanya ke https://dash.cloudflare.com/ dengan cara name servernya yang di ubah
b. Jika domain anda sudah di set ke cloudflare maka anda harus membuat DNS seperti gambar berikut ini :

![Screenshot_1](https://i.ibb.co/Xzr0494/photo-2023-09-12-14-23-24.jpg)

- Buat DNS dengan TYPE A  DAN  NAME NYA * LALU VALUE(CONTENT) BERISI IP ADDRES VPS TEMAN TEMAN
- Buat LAGI DNS dengan TYPE A  DAN  NAME NYA @ LALU VALUE(CONTENT) BERISI IP ADDRES VPS TEMAN TEMAN
c. Membuat DNS TYPE TXT dengan cara copy command di bawah ini dan ganti dengan domain yang kalian miliki misal domain.com  rubah menjadi alfonova.online
```
sudo certbot certonly --manual --preferred-challenges dns --email email@company.com -d domain.com -d '*.domain.com'
````
- Maka akan muncul seperti gambar berikut :  

![Screenshot_2](https://i.ibb.co/yXvwW6Y/photo-2023-09-12-14-32-13.jpg)
```
TOLONG JANGAN LANGSUNG DI ENTER JIKA MUNCUL 
SEPERTI INI UBAH DULU DATANYA  SEPERTI GAMBAR DNS TXT```

- Pergi ke cloudflare lagi dan membuat dns baru dengan  TYPE TXT

- Name isi dengan yang di berikan di vps contoh  _acme-challenge.alfonova.online.  saya mengisi nya di name sedangkan content nya berisi jWG6n9c1iFvBsY4pJIoek-4RAZnfNqFFXXGwhyTujdQ


# Mendownload File Node
Copy command di bawah ini lalu tunggu sampai download telah selesai jika sudah selesai teman teman buka folder yang telah kita download tadi
```
git clone https://github.com/ar-io/ar-io-node.git
cd ~/ar-io-node
```

# Menyiapkan Nginx
a. Pertama Hapus dulu page default nya dengan code sebagai berikut : 
```
rm /etc/nginx/sites-available/default
```
b. Selanjutnya membuat file baru dan mengisi file tersebut
```
nano /etc/nginx/sites-available/default
```
c. Selanjutnya mengisi file dengan script sebagai berikut :
```
server {
    listen 80;
    listen [::]:80;
    server_name  domain.com *.domain.com;

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name domain.com *.domain.com;

    ssl_certificate /etc/letsencrypt/live/domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/domain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
    }
}
```
domain.com ubah menjadi domain anda

d. Restart Nginx
```
sudo service nginx restart
sudo nginx -t
```

# Mengatur .env
- Buka notepad lalu ubah data ini sesuai data anda:
```
AR_IO_WALLET= ADDRES WALLET YANG TELAH KITA BUAT DI LANGKAH PERTAMA
ARNS_ROOT_HOST = domain yang telah kita setting tadi
AR_IO_WALLET=
GRAPHQL_HOST=arweave.net
GRAPHQL_PORT=443
START_HEIGHT=1000000
ARNS_ROOT_HOST=sipalingtestnet.com
```
- Jika sudah mengubah data diatas buka vps kembali lalu copy command berikut jika sudah jangan lupa tekan `CTRL+X` lalu `Y` lalu `ENTER` untuk keluar
```
cd ~/ar-io-node
nano .env
```

# Menjalankan Node
a. Copy command berikut lalu tunggu hinga proses instalasi berjalan hingga selesai
```
sudo docker compose up -d --build
```

# Mengambil Faucet
a. Pergi ke discord https://discord.gg/3yydrDCz lalu masuk ke channel #testnet
b. paste domain kamu https://domain.com/ar-io/info 

a. Export Wallet dengan cara masuk ke wallet yang telah di buat tadi lalu pergi ke pengaturan lalu pilih wallets lalu pilih `EXPORT WALLETS` janganlupa ubah nama filenya menjadi `key.json`

![Screenshot_3](https://i.ibb.co/rHH543v/spaces-z0v-OSDGNUtqq-Ex-Cr6pq-Y-uploads-j-MBCtw-Xgm-Jes-Gg-OR9-V2h-image.webp)
