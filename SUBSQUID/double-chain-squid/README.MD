# ON LINUX
## Install dependencies: Node.js, Docker, Git.


Install NodeJS (v16 or newer), Git and Docker using your distro's package manager.

```
sudo apt-get update && sudo apt install git -y && sudo apt install apt-transport-https ca-certificates curl software-properties-common -y && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
```

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.bashrc
nvm install 18
nvm use 18
```

```
mkdir ~/global-node-packages
```

then configure NodeJS to use it

```
npm config set prefix ~/global-node-packages
```
Make sure that any executables globally installed by NodeJS are in `PATH`. That allows running them from any terminal. Open the `~/.bashrc` file in a text editor and add the following line at the end:

```
export PATH="${HOME}/global-node-packages/bin:$PATH"
```

## Install Subsquid CLI

```
npm install --global @subsquid/cli@latest
```
```
sqd --version
```

## Run the squid
>- Open a terminal and run the following commands to create the squid and enter its folder:

```
sqd init my-double-proc-squid -t https://github.com/subsquid-quests/double-chain-squid
```
```
cd my-double-proc-squid
```

>- Press `Get Key` button in the quest card to obtain the `singleProc.key` key file. Save it to the `./query-gateway/keys` subfolder of the squid folder. The file will be used by the query gateway container.
>- The template squid uses a PostgreSQL database and a query gateway. Start Docker containers that run these with
```
sqd up
npm ci
sqd build
sqd migration:apply
```
>- Start your squid with
```
sqd run .
```

The squid should sync in 10-15 minutes. When it's done, stop it with Ctrl-C, then stop and remove the auxiliary containers with

```
sqd down
```




