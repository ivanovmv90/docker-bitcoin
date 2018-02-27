#!/bin/bash
set -e

mkdir -p "$BITCOIN_DATA"
mkdir -p "$BITCOIN_DATA2"

if [[ ! -s "$BITCOIN_DATA/bitcoin.conf" ]]; then
	cat <<-EOF > "$BITCOIN_DATA/bitcoin.conf"
	regtest=1
	rest=1
	server=1
	txindex=1
	printtoconsole=1
	rpcallowip=::/0
	rpcpassword=${BITCOIN_RPC_PASSWORD:-password}
	rpcuser=${BITCOIN_RPC_USER:-bitcoin}
	debug=rpc
	port=8332
	rpcport=49372
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA/bitcoin.conf"

	cat <<-EOF > "$BITCOIN_DATA2/bitcoin.conf"
	regtest=1
	rest=1
	server=1
	txindex=1
	printtoconsole=1
	rpcallowip=::/0
	rpcpassword=${BITCOIN_RPC_PASSWORD:-password}
	rpcuser=${BITCOIN_RPC_USER:-bitcoin}
	debug=rpc
	port=10340
	rpcport=12340
	EOF
	chown bitcoin:bitcoin "$BITCOIN_DATA2/bitcoin.conf"
fi

# ensure correct ownership and linking of data directory
# we do not update group ownership here, in case users want to mount
# a host directory and still retain access to it
chown -R bitcoin "$BITCOIN_DATA"
ln -sfn "$BITCOIN_DATA" /home/bitcoin/.bitcoin
chown -h bitcoin:bitcoin /home/bitcoin/.bitcoin

bitcoind -datadir=$BITCOIN_DATA

# bitcoind -datadir=$BITCOIN_DATA -daemon
# bitcoind -datadir=$BITCOIN_DATA2 -daemon
# bitcoin-cli -datadir=$BITCOIN_DATA generate 1
# bitcoin-cli -datadir=$BITCOIN_DATA addnode 127.0.0.1:10340 onetry
# bitcoin-cli -datadir=$BITCOIN_DATA2 generate 101

# cleanup ()                                                                 
# {                                                                          
#   kill -s SIGTERM $!                                                         
#   exit 0                                                                     
# }                                                                          
                                                                           
# trap cleanup SIGINT SIGTERM                                                
                                                                           
# while [ 1 ]                                                                
# do                                                                         
#   sleep 60 &                                                             
#   wait $!                                                                
# done