#!/bin/sh

# Quit on errors
set -o errexit

# Quit on unbound symbols
set -o nounset

# to be safe that all services are up and running
sleep 5

invenio roles create Marc21Curator
invenio roles create Marc21Manager
invenio roles create Marc21Creator
invenio alembic upgrade
invenio db create
invenio marc21 rebuild-index
invenio global-search rebuild-database
