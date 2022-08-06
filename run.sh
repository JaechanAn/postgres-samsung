#!/bin/bash

# Directories
BASE_DIR=$(pwd)

SCRIPT_DIR="${BASE_DIR}/scripts"

SRC_DIR="${BASE_DIR}/postgres"

INSTALL_DIR="${BASE_DIR}/pgsql"
BIN_DIR="${INSTALL_DIR}/bin"
LIB_DIR="${INSTALL_DIR}/lib"

DATA_DIR="${BASE_DIR}/data"

CONFIG_DIR="${BASE_DIR}/config"

# Scripts
INSTALL_SCRIPT="${SCRIPT_DIR}/install.sh"
INIT_SERVER_SCRIPT="${SCRIPT_DIR}/init_server.sh"
START_SERVER_SCRIPT="${SCRIPT_DIR}/start_server.sh"
CREATE_DB_SCRIPT="${SCRIPT_DIR}/create_db.sh"
STOP_SERVER_SCRIPT="${SCRIPT_DIR}/stop_server.sh"

LOGFILE="${BASE_DIR}/logfile"
CONFIGFILE="${CONFIG_DIR}/postgresql.conf"
CREATE_DB_SQL="${SCRIPT_DIR}/sql/create_db.sql"

# DB Config
USER="sdb1"
DATABASE="sdb1"
PORT=5678 # If you change the port, you must change the postgresql.conf file in config directory

# Parse parameters
for i in "$@"
do
  case $i in
    --install)
      INSTALL=YES
      shift
      ;;

    --initdb)
      INITDB=YES
      shift
      ;;

    --start)
      START=YES
      shift
      ;;

    --createdb)
      CREATEDB=YES
      shift
      ;;

    --stop)
      STOP=YES
      shift
      ;;

    *)
      # unknown option
      ;;
  esac
done

echo "INSTALL  = ${INSTALL}"
echo "INITDB   = ${INITDB}"
echo "START    = ${START}"
echo "CREATEDB = ${CREATEDB}"

# Install Postgres
if [[ "${INSTALL}" == "YES" ]]
then
    ${INSTALL_SCRIPT} \
      --base-dir=${BASE_DIR} \
      --src-dir=${SRC_DIR} \
      --install-dir=${INSTALL_DIR} \
      --compile-option="" \
      --configure
fi

# Init Server
if [[ "${INITDB}" == "YES" ]]
then
    ${INIT_SERVER_SCRIPT} \
      --bin-dir=${BIN_DIR} \
      --lib-dir=${LIB_DIR} \
      --data-dir=${DATA_DIR} \
      --configfile=${CONFIGFILE}
fi

# Start Server
if [[ "${START}" == "YES" ]]
then
    ${START_SERVER_SCRIPT} \
      --bin-dir=${BIN_DIR} \
      --data-dir=${DATA_DIR} \
      --logfile=${LOGFILE}
fi

# Create User & Database
if [[ "${CREATEDB}" == "YES" ]]
then
    ${CREATE_DB_SCRIPT} \
      --bin-dir=${BIN_DIR} \
      --user=${USER} \
      --port=${PORT} \
      --file=${CREATE_DB_SQL} \
      --database=${DATABASE}
fi

# Stop Server
if [[ "${STOP}" == "YES" ]]
then
    ${STOP_SERVER_SCRIPT} \
      --bin-dir=${BIN_DIR} \
      --data-dir=${DATA_DIR}
fi
