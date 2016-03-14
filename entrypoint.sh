#!/bin/bash
set -e
source ${SEAFILE_RUNTIME_DIR}/functions

initialize
configure

exec "$@"
