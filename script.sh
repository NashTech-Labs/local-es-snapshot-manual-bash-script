#!/bin/bash

# Sourcing all the envs
source config/es.env.sh

## Creating the payload json to be used to snapshot
envsubst < config/repo-payload-json.env.sh > config/repo-payload.json
envsubst < config/snapshot-payload-json.env.sh > config/snapshot-payload.json


#Checking if the ES is green
es_health=$(curl $es_url/_cluster/health --connect-timeout 10 | jq '.status' | tr -d '"')

if [[ $es_health != green ]]
then
    echo "Elastic search health must be green"
    exit 1
fi

#Checking if the repository exist
status_code=$(curl -s -o /dev/null -w "%{http_code}" $es_url/_snapshot/$repository_name)

if [[ $status_code -ne 200 ]]
then
    echo "Creating repo $repository_name"
    curl -XPUT $es_url/_snapshot/$repository_name -H 'Content-Type: application/json' -d @config/repo-payload.json
fi

#Creating the snapshot
snapshot_name=snapshot-$(date +"%d%m%Y")


##Checking if snapshot exist
status_code=$(curl -s -o /dev/null -w "%{http_code}" $es_url/_snapshot/$repository_name/$snapshot_name)

if [[ $status_code -eq 200 ]]
then
    echo ".....Skipping as snapshot with same name exist......."
    exit 0
fi

curl -XPUT $es_url/_snapshot/$repository_name/$snapshot_name -H 'Content-Type: application/json' -d @config/snapshot-payload.json
