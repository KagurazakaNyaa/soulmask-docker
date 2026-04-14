# soulmask-docker

[![Check Update](https://github.com/KagurazakaNyaa/soulmask-docker/actions/workflows/update.yml/badge.svg)](https://github.com/KagurazakaNyaa/soulmask-docker/actions/workflows/update.yml)
[![Build Docker Image](https://github.com/KagurazakaNyaa/soulmask-docker/actions/workflows/build.yml/badge.svg)](https://github.com/KagurazakaNyaa/soulmask-docker/actions/workflows/build.yml)

![Docker Pulls](https://img.shields.io/docker/pulls/kagurazakanyaa/soulmask)
![Docker Stars](https://img.shields.io/docker/stars/kagurazakanyaa/soulmask)
![Image Size](https://img.shields.io/docker/image-size/kagurazakanyaa/soulmask/latest)

Soulmask dedicated server with docker

## Environments

The variables in the table below affect the server's startup command, see <https://soulmask.fandom.com/wiki/Private_Server>

| Variable                     | Describe                                                                                                      | Default Values  | Allowed Values   |
|------------------------------|---------------------------------------------------------------------------------------------------------------|-----------------|------------------|
| LEVEL_NAME                   | Specifies the game scene name, currently there is only one: Level01_Main.                                     | Level01_Main    | Level01_Main     |
| GAME_PORT                    | Specifies the game port, UDP, needs to be open to the public.                                                 | 8777            | 1024-65535       |
| QUERY_PORT                   | Specifies the Steam query port, UDP, needs to be open to the public.                                          | 27015           | 1024-65535       |
| ECHO_PORT                    | Maintenance port, used for local telnet server maintenance, TCP, does not need to be open.                    | 18888           | 1024-65535       |
| MAX_PLAYERS                  | Specifies the maximum number of players the game instance can support.                                        | 20              | Positive integer |
| SERVER_NAME                  | Specifies the name of the game instance displayed in the server list, string type.                            | Soulmask Server | string           |
| SAVED_DIR_SUFFIX             | Specifies this game instance used saved directory suffix, string type.                                        |                 | string           |
| SOULMASK_SERVER_ID           | Unique server ID within a cluster. Required on clustered servers.                                             |                 | Positive integer |
| SOULMASK_CLUSTER_MAIN_PORT   | Main server cluster port. Setting this makes the server act as the cluster main server.                       |                 | 1024-65535       |
| SOULMASK_CLUSTER_MAIN_CONNECT| Main server address for client cluster servers. Setting this makes the server act as a cluster client.       |                 | IP:PORT          |
| SERVER_PASSWORD              | Server password, private servers can specify a password, players must enter the password to enter the server. |                 | string           |
| ADMIN_PASSWORD               | GM activation password.Open GM Panel (`gm key [password]`)                                                    | changeme        | string           |
| MOD_ID_LIST                  | Mod's workshop ID list, split by `,`.                                                                         |                 | integer list     |
| INIT_BACKUP                  | Backs up game saves when the game starts.                                                                     | false           | true/false       |
| BACKUP_INTERVAL_MINUTES      | Specifies how often (minutes) to automatically back up the world save.                                        | 30              | Positive integer |
| SAVING_SYNC_INTERVAL_SECONDS | Specifies the interval for writing game objects to the database (unit: seconds).                              | 120             | Positive integer |
| BACKUP_SYNC_INTERVAL_SECONDS | Specifies the interval for writing the game database to disk (unit: seconds).                                 | 120             | Positive integer |
| GAME_MODE                    | Specifies the game mode.                                                                                      | pve             | pve/pvp          |
| FORCE_UPDATE                 | Whether the server should be update each time start.                                                          | false           | true/false       |

## Volumes

| Path                     | Describe               |
|--------------------------|------------------------|
| `/opt/soulmask/WS/Saved` | Game config and saves. |

NOTE: If you use bind instead of volume to mount, you need to manually change the volume owner to uid=1000.
In the case of the docker-compose.yml of the example, you need to execute `chown -R 1000:1000 ./data`
Please make sure the permissions and owners of the pak file you placed in the mods directory are correct.

## Cluster

- `SOULMASK_SERVER_ID` is required for any clustered server.
- Use `SOULMASK_CLUSTER_MAIN_PORT` on the main server, or `SOULMASK_CLUSTER_MAIN_CONNECT` on client servers.
- Outbound character transfer is controlled by the in-game Cross-server Mode setting (`KaiQiKuaFu` in `GameplaySettings/GameXishu.json`) and is not managed by container environment variables.

### Main server example

```yaml
services:
  dedicated-server:
    environment:
      - SERVER_NAME=Soulmask Cluster Main
      - SOULMASK_SERVER_ID=1
      - SOULMASK_CLUSTER_MAIN_PORT=18000
```

### Client server example

```yaml
services:
  dedicated-server:
    environment:
      - SERVER_NAME=Soulmask Cluster Node 2
      - SOULMASK_SERVER_ID=2
      - SOULMASK_CLUSTER_MAIN_CONNECT=192.168.1.10:18000
```

Replace `192.168.1.10:18000` with the address and cluster port exposed by your main server. Each server in the cluster must use a unique `SOULMASK_SERVER_ID`.
