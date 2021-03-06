#!/usr/bin/env bash
set -e

source /home/aiida/venv/bin/activate

sudo /etc/init.d/postgresql start
sudo /etc/init.d/rabbitmq-server start
sudo -u postgres psql -c "CREATE USER aiida WITH PASSWORD 'password';"
sudo -u postgres psql -c "CREATE DATABASE aiidadb OWNER aiida ENCODING 'UTF8' LC_COLLATE='en_US.UTF-8' LC_CTYPE='en_US.UTF-8' TEMPLATE=template0;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE aiidadb to aiida;"

verdi setup \
    --profile default \
    --non-interactive \
    --db-backend django \
    --db-host localhost \
    --db-port 5432 \
    --db-name aiidadb \
    --db-username aiida \
    --db-password password \
    --repository /home/aiida/scratch \
    --email email@institution.ch \
    --first-name User --last-name Last \
    --institution institution

verdi computer setup \
    --non-interactive \
    --label localhost \
    --hostname localhost \
    --description "Best computer in the world" \
    --transport "local" \
    --scheduler direct \
    --work-dir "/home/{username}/scratch/" \
    --mpiprocs-per-machine 4

verdi computer configure "local" localhost \
    --non-interactive \
    --safe-interval 0

verdi code setup \
    --non-interactive \
    --label pw.x \
    --on-computer \
    --computer localhost \
    --remote-abs-path /usr/bin/pw.x \
    --input-plugin quantumespresso.pw

verdi code setup \
    --non-interactive \
    --label cp.x \
    --on-computer \
    --computer localhost \
    --remote-abs-path /usr/bin/cp.x \
    --input-plugin quantumespresso.cp

verdi data upf uploadfamily \
    ./SSSP_efficiency_pseudos \
    "SSSP-Efficiency" \
    "Collection of SSSP Efficiency pseudos"
