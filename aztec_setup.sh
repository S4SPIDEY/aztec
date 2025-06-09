#!/bin/bash
set -e

sudo apt-get update && sudo apt-get upgrade -y

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt update && sudo apt install -y nodejs

sudo apt install -y curl iptables build-essential git wget lz4 jq make gcc nano automake autoconf tmux htop nvme-cli libgbm1 pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev screen ufw apt-transport-https ca-certificates software-properties-common

# Docker install
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update && sudo apt install -y docker-ce
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
newgrp docker

# Docker Compose install
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .tag_name)
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker --version
docker-compose --version

# Aztec CLI install
bash -i <(curl -s https://install.aztec.network)

echo 'export PATH="$HOME/.aztec/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

aztec -h
aztec-up latest

# Firewall setup
sudo ufw allow 22
sudo ufw allow ssh
sudo ufw allow 40400
sudo ufw allow 8080
sudo ufw --force enable

# Prompt user for aztec start parameters and run
#ETH_SEPOLIA_RPC="https://your-fixed-eth-sepolia-rpc-url"
#ETH_BEACON_SEPOLIA_RPC="https://your-fixed-eth-beacon-sepolia-rpc-url"

read -p "Enter Eth_Sepolia_RPC URL: " ETH_SEPOLIA_RPC
read -p "Enter Eth-beacon_sepolia_RPC URL: " ETH_BEACON_SEPOLIA_RPC


read -p "Enter wallet private key (add 0x at start): " WALLET_PRIVATE_KEY
read -p "Enter your wallet address (YourAddress): " WALLET_ADDRESS
read -p "Enter your P2P IP address: " P2P_IP

aztec start --node --archiver --sequencer \
  --network alpha-testnet \
  --l1-rpc-urls "$ETH_SEPOLIA_RPC" \
  --l1-consensus-host-urls "$ETH_BEACON_SEPOLIA_RPC" \
  --sequencer.validatorPrivateKey "$WALLET_PRIVATE_KEY" \
  --sequencer.coinbase "$WALLET_ADDRESS" \
  --p2p.p2pIp "$P2P_IP" \
  --p2p.maxTxPoolSize 1000000000
