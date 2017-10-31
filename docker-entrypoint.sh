#!/bin/sh

 /geth --nodiscover --maxpeers "0" --rpc --rpcapi "rpc,debug,txpool,personal,db,eth,net,web3" --rpcport "8545" --rpccorsdomain "*" --rpcaddr "0.0.0.0" --port "30303" --identity "SabbirGethNode" --verbosity "5"