FROM cm2network/steamcmd:steam

USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y netcat-openbsd && apt-get clean

USER steam
WORKDIR /opt/soulmask

RUN /home/steam/steamcmd/steamcmd.sh \
    +force_install_dir "/opt/soulmask" \
    +login anonymous \
    +app_update 3017300 validate \
    +quit

ENV FORCE_UPDATE=false

ENV LEVEL_NAME=Level01_Main
ENV GAME_PORT=8777
ENV QUERY_PORT=27015
ENV ECHO_PORT=18888
ENV MAX_PLAYERS=20
ENV SERVER_NAME="Soulmask Server"
ENV SAVED_DIR_SUFFIX=
ENV SERVER_PASSWORD=
ENV ADMIN_PASSWORD=changeme
ENV INIT_BACKUP=true
ENV BACKUP_INTERVAL_MINUTES=30
ENV SAVING_SYNC_INTERVAL_SECONDS=120
ENV BACKUP_SYNC_INTERVAL_SECONDS=120
ENV GAME_MODE=pve
ENV MOD_ID_LIST=

COPY --chmod=0755 docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE ${GAME_PORT}/udp ${QUERY_PORT}/udp ${ECHO_PORT}/tcp

# fix permission
RUN mkdir -p /opt/soulmask/WS/Saved
VOLUME [ "/opt/soulmask/WS/Saved"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]