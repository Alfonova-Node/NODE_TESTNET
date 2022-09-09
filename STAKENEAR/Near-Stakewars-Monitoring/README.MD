# NEAR stakewars monitoring
![Screenshot](https://user-images.githubusercontent.com/29555611/182002987-32b9e884-845d-4515-8147-e8ba55094553.png)

This is one-line bash script to get node_exporter-prometheus-grafana + grafana dashboard installed for monitoring Near stakewars Validator Node.
Testnet: https://github.com/near/stakewars-iii

### Prerequisite:
- It is assumed that there is no node_exporter/prometheus/grafana installed
- It is assumed ports: 9100, 9090, 3000 are not in use

### How to use:
On Near validator server run
```bash
wget -q -O near-stakewars-monitoring-installer.sh https://raw.githubusercontent.com/davaymne/near-stakewars-monitoring/main/near-stakewars-monitoring-installer.sh && chmod +x near-stakewars-monitoring-installer.sh && sudo /bin/bash near-stakewars-monitoring-installer.sh
```
Go to you web browser and enter:
```bash
http://YOUR-NODE-IP:3000/
```
Use Grafana default credentials:

 - User: admin
 - Pass: admin



## Dashboard screenshots
-  Create NEAR general dashboard.

![Screenshot 1](https://i.ibb.co/3vNdzHb/msg-1789191181-1516.jpg)

- Create or reconfigure the existing dashboard for monitoring CPU, RAM, file systems, disks, and network statistics.

![Screenshot 2](https://i.ibb.co/C07Kc4N/msg-1789191181-1519.jpg)
