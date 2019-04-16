#!/usr/bin/env bash
set -e
sudo /etc/init.d/rabbitmq-server start
sudo /etc/init.d/postgresql start
source ../venv/bin/activate
exec "$@"
