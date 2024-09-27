#!/bin/bash
set -e
# SIGTERM-handler
term_handler() {
    printf 'exit 1\r\n' | nc localhost "$ECHO_PORT"
    wait "$pid"
    exit 0
}

if [[ -n $FORCE_UPDATE ]] && [[ $FORCE_UPDATE == "true" ]]; then
    /home/steam/steamcmd/steamcmd.sh +force_install_dir "/opt/soulmask" +login anonymous +app_update 3017300 validate +quit
fi

extra_opts=()
if [[ -n $INIT_BACKUP ]] && [[ $INIT_BACKUP == "true" ]]; then
    extra_opts+=("-initbackup")
fi
if [[ -n $BACKUP_INTERVAL_MINUTES ]]; then
    extra_opts+=("-backupinterval=${BACKUP_INTERVAL_MINUTES}")
fi
if [[ -n $SAVED_DIR_SUFFIX ]]; then
    extra_opts+=("-saveddirsuffix=\"${SAVED_DIR_SUFFIX}\"")
fi
if [[ -n $ADMIN_PASSWORD ]]; then
    extra_opts+=("-adminpsw=\"${ADMIN_PASSWORD}\"")
fi
if [[ -n $SERVER_PASSWORD ]]; then
    extra_opts+=("-PSW=\"${SERVER_PASSWORD}\"")
fi
if [[ -n $GAME_MODE ]]; then
    if [[ $GAME_MODE == "pve" ]]; then
        extra_opts+=("-pve")
    elif [[ $GAME_MODE == "pvp" ]]; then
        extra_opts+=("-pvp")
    fi
fi
if [[ -n $MOD_ID_LIST ]]; then
    extra_opts+=("-mod=\"${MOD_ID_LIST}\"")
fi

trap 'term_handler' SIGTERM SIGHUP SIGINT EXIT
if [ $# -eq 0 ]; then
    proc_result=128
    proc_serial=1
    while [ $proc_result == 128 ]; do
        /home/steam/steamcmd/steamcmd.sh +login anonymous +quit
        ./WSServer.sh "${LEVEL_NAME}" -server -SLIENT -log -UTF8Output -SteamServerName=\""${SERVER_NAME}"\" -MaxPlayers="${MAX_PLAYERS}" -backup="${BACKUP_SYNC_INTERVAL_SECONDS}" -saving="${SAVING_SYNC_INTERVAL_SECONDS}" -MULTIHOME=0.0.0.0 -Port="${GAME_PORT}" -QueryPort="${QUERY_PORT}" -EchoPort="${ECHO_PORT}" -online=Steam -forcepassthrough "${extra_opts[@]}" &
        proc_result=$?
        pid=$!
        echo pid=$pid result=$proc_result
        proc_serial=$((proc_serial + 1))
        wait $pid
    done
else
    exec "$@"
fi
