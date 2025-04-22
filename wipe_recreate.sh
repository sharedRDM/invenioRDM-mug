#!/bin/sh

# Quit on errors
set -o errexit

# Quit on unbound symbols
set -o nounset

# to be safe that all services are up and running
sleep 5

invenio shell --no-term-title -c "import redis; redis.StrictRedis.from_url(app.config['CACHE_REDIS_URL']).flushall(); print('Cache cleared')"
invenio db drop --yes-i-know
invenio index destroy --force --yes-i-know
invenio index queue init purge
invenio db create
invenio files location create --default 'default-location' /opt/invenio/var/instance/data
invenio roles create administrator
invenio access allow superuser-access role administrator
invenio index init --force
invenio rdm-records fixtures
