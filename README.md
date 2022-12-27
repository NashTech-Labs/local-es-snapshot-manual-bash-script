# README

This script takes input some envs and based on the env values forms payload json files. Then uses these payload json files to create a snapshot. This script can be executed

## Env Table

Make changes to the ENV values only in config/es.env.sh

| ENV name | Description |
| - | - |
| repository_name | Name of the repository which exist or will be created |
| snapshot_name | Name of the snapshot to be created |
| indices | Indices whose snapshot is to be created (eg. index1,index2 OR index-*) |
| partial | If aprtial snapshot is allowed(true or false) |
| include_global_state | If global cluster state is to be included (true or false) |
| ignore_unavailable | If ignore unavailable shards (true or false) |
| es_url | Url of the ES in the form http://host:port |
| LOCAL_PATH | Path on the node to store the snapshot |

## Execute 

```
chmod +x script.sh
./script.sh
```