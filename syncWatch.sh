#!/bin/bash

syncing=true

while [[ $syncing = true ]]
do
    curlResult=$(curl --data '{"method":"eth_syncing","params":[],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST localhost:8545)
    echo $curlResult
    synced=$(echo $curlResult | jq '.result == false')
    echo $synced
    if $synced; then
      break
    fi
    currentBlock=$(echo $curlResult | jq '.result.currentBlock')
    highestBlock=$(echo $curlResult | jq '.result.highestBlock')
    echo "Syncstatus current $currentBlock hightest: $highestBlock"
    sleep 10s
done

exit