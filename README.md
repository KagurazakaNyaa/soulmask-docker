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
