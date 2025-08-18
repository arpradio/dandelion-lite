<!-- ![Example Image](images/Koios.png) -->

```
___  ____ __ _ ___  ____ _    _ ____ __ _
|__> |--| | \| |__> |=== |___ | [__] | \|
                                   lite
```
# 🚀 Join the Dandelion Network!

**Join the Dandelion Network as a DNO (Dandelion Node Operator) for helping students and developers to jump into building with ease and help us decentralize Cardano dapps and services further**

*DNOs will be incentivized in the future, we are actively working on modular, and client side revenue channels and alternative compensation methods for your efforts. For now please support us on Catalyst to walk our first steps together*:

[ ❤️ Support the Dandelion Network on Catalyst](https://github.com/GameChangerFinance/gamechanger.wallet/blob/main/catalyst/FUND13.md)

 [⚠️⚠️ LATEST UPDATES! ⚠️⚠️](#relay-node-configuration)

# What's this?

**Dandelion** is a community-supported project led by GimbaLabs and operated by La PEACEpool Cardano repsist₳nce. Every Cardano API available. From bottom to top, from testnet to mainnet.

**Dandelion Lite** is a convenient way of deploying your own local Cardano Node and a set of Dandelion APIs. It uses docker-compose, podman and handy scripts to ease the setup and reduce node syncronization times by using volume snapshots for backup and restore procedures. Dandelion Lite is a fork of Koios Lite, extending it beyond Koios, created by GameChanger Finance and M2Tec teams.

## Components

This setup includes several key components:

- `cardano-node-ogmios`: Runs the Cardano node plus the lightweight bridge interface Ogmios.
- `cardano-db-sync`: Synchronizes the blockchain data to a PostgreSQL database.
- `haproxy`: A high-performance proxy to distribute network traffic among various components.
- `postgres`: The PostgreSQL database, storing the synchronized blockchain data.
- `koios`: RESTful API for Cardano, based on PostGREST, adapted for Dandelion Lite. 
- `blockfrost`: RESTful API for Cardano, using `blockfrost-ryo` official images. 
- `cardano-graphql`: Official GraphQL API for Cardano.
- `cardano-token-registry`: Official Token Registry API for Cardano.
- `cardano-submit-api`: Official Transactions Submit API for Cardano.
- `dandelion-postgrest`: Dandelion PostGREST API for Cardano, a RESTful API for querying the blockchain data stored in PostgreSQL
- `cardano-sql`: (MVP - WIP) PosgreSQL-over-HTTP API gateway wrapping several services such as
    - ogmios
    - cardano-db-sync
    - cardano-graphql
    - koios
    - dandelion-postgrest
    - cardano-token-registry
    - more..
- `manifest`: JSON information of deployed Dandelion Lite Node, required for client applications and for joining the Dandelion Network of decentralized nodes
- `home`: HTML landing website of deployed Dandelion Lite Node 
- `backups`: your volume backups hosted with password protection 

Each service is containerized and managed via Docker, ensuring easy deployment and scalability.

## Hardware Requirements (10-10-2024):

Suggested setup for concurrent **Cardano Mainnet** and **Preproduction Testnet** with volume backups consists on

- 128GB RAM (DDR4 ECC RAM)
- 2TB M2 NVME for storage
- Dual Intel Xeon E5 2680 v4 (LGA 2011-3 motherboard)

### Volume sizes

These are sizes of the volumes used by the containers of recent production deployments.

Using: `$ ./scripts/docker/list-volume-sizes.sh`

Last updated: 10/10/2024

### Cardano Mainnet   

    25G     gc-node-mainnet_db-sync-data
    445M    gc-node-mainnet_dbless-cardano-token-registry-data
    187G    gc-node-mainnet_node-db
    8.0K    gc-node-mainnet_node-ipc
    512G    gc-node-mainnet_postgresdb
    8.0K    gc-node-mainnet_unimatrix-data

    Total   724.43 GB

### Cardano Pre-Production Testnet

    3.9G    gc-node-preprod_db-sync-data
    41M     gc-node-preprod_dbless-cardano-token-registry-data
    8.8G    gc-node-preprod_node-db
    8.0K    gc-node-preprod_node-ipc
    16G     gc-node-preprod_postgresdb
    8.0K    gc-node-preprod_unimatrix-data

    Total   28.74 GB


### Volume Backup Sizes

These are sizes of compressed backups of container volumes on recent production deployments. Is not estrictly required to take these disk space lists into consideration for hardware adquisition but is adviced as working without snapshots can delay node syncing times even for more than a week.

Full volumes backup and restore procedures can be run manually by helper scripts or using the menu on `$ ./scripts/dandoman.sh`.

Last updated: 10/10/2024

### Cardano Mainnet
        
    17G     db-sync-data.tar.gz
    377M    dbless-cardano-token-registry-data.tar.gz
    97G     node-db.tar.gz
    4.0K    node-ipc.tar.gz
    12K     pgadmin-data.tar.gz
    4.0K    portainer-data.tar.gz
    137G    postgresdb.tar.gz
    4.0K    unimatrix-data.tar.gz
    
    Total   250G


### Cardano Pre-Production Testnet
   
    
    1.7G    db-sync-data.tar.gz
    16M     dbless-cardano-token-registry-data.tar.gz
    3.8G    node-db.tar.gz
    4.0K    node-ipc.tar.gz
    12K     pgadmin-data.tar.gz
    4.0K    portainer-data.tar.gz
    3.8G    postgresdb.tar.gz
    4.0K    unimatrix-data.tar.gz

    Total   9.3G

## Software Requirements (10-10-2024):

Reported to be working on:

- Ubuntu Server version 24.04 (normal, not minimal install)

## Deployment

### Base system install

As a base system we use **ubuntu-server version 24.04**. We use the normal install not the minimal one. Also install **OpenSSH** server to allow for system administration. 

1. When install is completed do `ip -br a` to get the ip address of your newly installed server 
2. From you local system. So not on your server do `ssh-copy-id USER_NAME@SERVER_IP` This will copy your ssh keys to the server to allow easy login
3. Do `ssh USER_NAME@SERVER_IP`

To deploy or run Dandelion Lite:
1. Clone the repository to your local machine.`$ git clone https://github.com/GameChangerFinance/dandelion-lite.git dandelion-lite-preprod`. Put every network you sync into it's own folder. 
2. Change current directory `$ cd dandelion-lite`
2. Run `./scripts/dandoman.sh --podman-install` to install podman. Exit your user session with `$ exit`and log back in with ssh or your preferred method.
3. Run Admin Tool `scripts/dandoman.sh` for setting up an initial `.env` file and installing dependencies such as Docker Compose and Podman. Exit the gui by menu or `CTRL-C`. Exit your user session with `$ exit` and log back in with ssh or your preferred method.
4. Edit/configure the environment variables the `.env` file. You can base it on the provided `env.example.<NETWORK>`.
5. Run `scripts/dandoman.sh` > `Docker->Docker Up/Reload` on Admin Tool or `docker compose up -d` to start the services.
6. Monitor that node has reached tip and `scripts/dandoman.sh` > `Docker->Docker Status` to ensure none of the containers are `DOWN` or `UP (unhealthy)` state.
7. Once on tip, execute `scripts/dandoman.sh` > `Setup->Initialise Postgres` to deploy custom RPCs and test via PostgREST/HAProxy endpoints using curl:
```bash
# Check if the node is synced using docker
docker inspect --format "{{json .State.Health }}" dandolite-preprod-cardano-node-ogmios-1 | jq

# Check if db-sync is ready 
docker inspect --format "{{json .State.Health }}" dandolite-preprod-cardano-db-sync-1 | jq

# Koios tip check
curl http://127.0.0.1:8050/koios/v1/tip
```

Remember to secure your deployment according to best practices, including securing your database and API endpoints.

### Autostart

To auto run on system start:
1. Execute `scripts/dandoman.sh` > `Setup->Run on system start` and follow steps.


### Download a Full Remote Backup

Syncing Cardano node and databases can take even more than a week, it is adviced for you to download compressed snapshots of the databases to get you started.

1. Set the `BACKUP_DIR` environment variable on `.env` file with the location on where you want to store the files, like `BACKUP_DIR="/home/${USER}/backups/${NETWORK}/"`. Check [Volume Backup Sizes](#volume-backup-sizes) for estimating the required size.
2. Execute `scripts/dandoman.sh` > `Setup->Download Backup` and follow steps.

```
Enter the URL for remote backup download (with trailing slash): https://example.dandelion.node/backups/        
Enter remote username (optional): backup
Enter remote password (optional): *********
About to download backups from 'https://example.dandelion.node/backups/' into '/home/DandelionUser/backups/preprod/'
Press key to continue.. (Ctrl + C to abort)
...
✅ All done.
```

### Run a Full Deploy Backup

Syncing Cardano node and databases can take even more than a week, it is adviced for you to take compressed snapshots or backups of your databases after 2 or 3 of months at least.
1. Set the `BACKUP_DIR` environment variable on `.env` file with the location on where you want to store the files, like `BACKUP_DIR="/home/${USER}/backups/${NETWORK}/"`. Check [Volume Backup Sizes](#volume-backup-sizes) for estimating the required size.
2. Customize `NGINX_WWW_BACKUP_USER` and `NGINX_WWW_BACKUP_PASSWORD` to protect with a password the hosting of your backup files
3. Execute `scripts/dandoman.sh` > `Setup->Full backup` and follow steps.

### Run a Full Deploy Restore

This will **WIPE ALL YOUR DEPLOYMENT DATA** and will restore a previous backup:
1. Set the `BACKUP_DIR` environment variable on `.env` file with the location from where you want to read the stored files, like `BACKUP_DIR="/home/${USER}/backups/${NETWORK}/"`. Check [Volume Backup Sizes](#volume-backup-sizes) for estimating the required size.
2. Execute `scripts/dandoman.sh` > `Setup->Full restore` and follow steps.


### SSL

You can terminate your connections with SSL encryption by setting up SSL certificate on Haproxy

1. Place your `server.pem` file on `configs/ssl/`. You can create a self signed certificate like this `$ ./scripts/ssl/keygen.sh <domain> <file-prefix>"`
2. Uncomment SSL line and comment the default one on `config/haproxy/haproxy.cfg`, like this:

```
frontend app
  # for non SSL encription termination
  # bind 0.0.0.0:8053
  ## If using SSL, comment line above and uncomment line below
  bind 0.0.0.0:8053 ssl crt /etc/ssl/server.pem no-sslv3

```


### Dynamic DNS

You can run an IP updater cron job for making your dynamic IP available using a DNS domain name.

For DuckDNS:

1. Uncomment and setup your `.env` lines to something unique like this (AVOID TICKER AND NAME COLLISIONS!):

```
NODE_NAME="MyOwnCardanoNode01"
NODE_TICKER="node1"
NODE_GROUPS='[]' # for offering node for decentralizing Cardano dapps and services

DUCKDNS_DOMAINS="${NODE_TICKER}-dandelion-node"
DUCKDNS_TOKEN="<API_TOKEN>"

```


## Admin tool
A simple script to interact with the all the components of a Dandelion Lite Node:
[Admin Tool Documentation](AdminTool.md)

```bash
>scripts/dandoman.sh --help

Dandelion Lite Administration Tool Help Menu:
------------------------------------

Welcome to the Dandelion Lite Administration Tool Help Menu.

Below are the available commands and their descriptions:

--about: 			     Displays information about the Koios administration tool.
--install-dependencies:  Installs necessary dependencies.
--check-podman: 		 Checks if Podman is running.
--podman-install: 		 Installs Podman. 
--check-docker: 		 Checks if Docker is running.
--docker-install: 		 Installs Docker.
--handle-env-file: 		 Manage .env file.
--reset-env: 			 Resets the .env file to defaults.
--docker-status: 		 Shows the status of Docker containers.
--docker-up: 			 Starts Docker containers defined in docker compose.yml.
--docker-down: 			 Stops Docker containers defined in docker compose.yml.
--enter-node: 			 Accesses the Cardano Node container.
--logs-node: 			 Displays logs for the Cardano Node container.
--gliveview: 			 Executes gLiveView in the Cardano Node container.
--cntools: 			     Runs CNTools in the Cardano Node container.
--enter-postgres: 		 Accesses the Postgres container.
--logs-postgres: 		 Displays logs for the Postgres container.
--enter-dbsync: 		 Accesses the DBSync container.
--logs-dbsync: 			 Displays logs for the DBSync container.
--enter-haproxy: 		 Accesses the HAProxy container.
--logs-haproxy: 		 Displays logs for the HAProxy container.
```

## System monitoring tools 

You can install glances to keep an eye on how your system is performing

```bash 
sudo apt install glances 
```

### Swap memory

In case you see high swap usage in `glances` or other monitor tool, this is happens because we are running systems with a lot of memory consumption. 

Use the following commands to increase swap memory allocation. 

Make sure your dandelion nodes are down by running in the folders where you cloned the dandelion git into:

```bash
docker compose down
``` 

Once you have a not busy system do the following:

```bash
swapon --show
sudo swapoff -v /swap.img
sudo rm -rf /swap.img 
sudo fallocate -l 40G /swap.img
sudo chmod 0600 /swap.img
sudo mkswap /swap.img 
sudo swapon
sudo reboot now 

```
## Notes

### Koios Support

Due to special **Koios** requirements on **cardano-db-sync** database setup ( [variant schema](https://github.com/IntersectMBO/cardano-db-sync/blob/master/doc/schema.md#variant-schema) ), it makes it not fully compatible with other APIs like **Blockfrost** and **cardano-graphql**.

As it is not adviced to run 2 **cardano-db-sync** instances to keep also other APIs working under the same setup, we offer out of the box a semi-working **Koios** API (without *variant schema*), and if you setup **cardano-db-sync** properly you can get it working at full, but affecting the other services.

Default **Koios** support can be examined with it's latest test reports
- [preprod](tests/koios/preprod.report)
- [mainnet](tests/koios/mainnet.report)

### Blockfrost Support

All basic endpoints + **cardano-submit-api** + **ogmios** are supported. Other auxiliar endpoints are yet to be tested.

Default **Blockfrost RYO** support can be examined with it's latest test reports
- [preprod](tests/blockfrost/preprod.report)
- [mainnet](tests/blockfrost/mainnet.report)

### Relay Node Configuration

To enable relay capabilities, simply edit the [topology.config](./configs/cardano/config/network/mainnet/cardano-node/topology.json) with your block producer (localRoots) and/or relay (publicRoots) IP addresses.  Make sure `valency` value is set to the amount of nodes you list.
