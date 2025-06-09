echo
echo "✅ Aztec node started. Extracting peer ID..."

# Extract and show Peer ID
PEER_ID=$(sudo docker logs $(docker ps -q --filter ancestor=aztecprotocol/aztec:latest | head -n 1) 2>&1 | grep -i "peerId" | grep -o '"peerId":"[^"]*"' | cut -d'"' -f4 | head -n 1)

if [ -n "$PEER_ID" ]; then
  echo "Your Aztec node Peer ID is: $PEER_ID"
else
  echo "⚠️ Peer ID not found. Please check docker logs manually."
fi

echo
echo "🔑 Your Aztec P2P private key is:"
cat ~/.aztec/alpha-testnet/data/p2p-private-key && echo
