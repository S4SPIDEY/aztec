#!/bin/bash

# Prompt the user for inputs
read -p "Please Provide Sepolia RPC (Port 8545): " SEPOLIA_RPC
read -p "Please Provide Beacon RPC (Port 3500): " BEACON_RPC
read -p "Wallet Private Key with 0x: " PRIVATE_KEY_WITH_0X
read -p "EVM wallet address: " EVM_ADDRESS

# Show public IP
echo "🔍 Detecting your public IP address..."
PUBLIC_IP=$(curl -s https://ifconfig.me)
echo "📡 Your current public IP is: $PUBLIC_IP"

read -p "VPS external IP address (press Enter to use detected IP): " VPS_IP
VPS_IP=${VPS_IP:-$PUBLIC_IP}

# Start the Aztec node with provided inputs
echo "🟢 Starting Aztec node..."
aztec start --node --archiver --sequencer \
  --network alpha-testnet \
  --l1-rpc-urls "$SEPOLIA_RPC" \
  --l1-consensus-host-urls "$BEACON_RPC" \
  --sequencer.validatorPrivateKey "$PRIVATE_KEY_WITH_0X" \
  --sequencer.coinbase "$EVM_ADDRESS" \
  --p2p.p2pIp "$VPS_IP" \
  --p2p.maxTxPoolSize 1000000000
