##!/bin/bash

syncing=true

while [[ $syncing = true ]]
do
    curlResult=$(curl --retry 300 --retry-delay 5 -s --data '{"method":"eth_syncing","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545)
    synced=$(echo $curlResult | jq '.result.currentBlock == "0x7698F"')
    if $synced; then
      break
    fi
    currentBlock=$(echo $curlResult | jq '.result.currentBlock')
    highestBlock=$(echo $curlResult | jq '.result.highestBlock')
    echo "Syncstatus current $currentBlock hightest: $highestBlock"
    sleep 10s
done

exit
