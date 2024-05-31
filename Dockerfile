FROM cm2network/steamcmd:steam

ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /opt/soulmask

RUN /home/steam/steamcmd/steamcmd.sh +force_install_dir "/opt/soulmask" +login anonymous +app_update 3017300 validate +quit

ENV FORCE_UPDATE=false

ENV LEVEL_NAME=Level01_Main
ENV GAME_PORT=7777
ENV QUERY_PORT=27015
ENV ECHO_PORT=18888
ENV MAX_PLAYERS=20
ENV SERVER_NAME="Soulmask Server"
ENV SAVED_DIR_SUFFIX=
ENV SERVER_PASSWORD=
ENV ADMIN_PASSWORD=changeme
ENV INIT_BACKUP=true
ENV BACKUP_INTERVAL_MINUTES=10
ENV SAVING_SYNC_INTERVAL_SECONDS=600
ENV BACKUP_SYNC_INTERVAL_SECONDS=900

ADD docker-entrypoint.sh /docker-entrypoint.sh

EXPOSE ${GAME_PORT}/udp ${QUERY_PORT}/udp ${ECHO_PORT}/tcp

# fix permission
RUN mkdir -p /opt/soulmask/WS/Saved
VOLUME [ "/opt/soulmask/WS/Saved"]

ENTRYPOINT [ "/docker-entrypoint.sh" ]