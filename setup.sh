#!/usr/bin/bash

set -eux

mkdir -p data
if [ ! -f data/chugoku-latest.osm.pbf ]; then
  wget https://download.geofabrik.de/asia/japan/chugoku-latest.osm.pbf -P data
fi
if [ ! -f data/kansai-latest.osm.pbf ]; then
  wget https://download.geofabrik.de/asia/japan/kansai-latest.osm.pbf -P data
fi

docker compose down --volumes

docker compose build --no-cache
docker compose up -d

docker compose exec db psql -U nominatim -d postgres -c 'CREATE ROLE "www-data" LOGIN;'

if [ ! -f data/merged.osm.pbf ]; then
  docker compose exec nominatim bash -c 'osmium merge /nominatim/data/*.osm.pbf -o /nominatim/data/merged.osm.pbf'
fi
time docker compose exec nominatim nominatim import --osm-file /nominatim/data/merged.osm.pbf

time docker compose exec -T nominatim cat /nominatim/src/contrib/pgroonga/setup.sql |
  docker compose exec -T db psql -U nominatim -d nominatim

docker compose exec db psql -U nominatim -d nominatim --command "SELECT count(*) FROM search_name;"

docker compose exec db bash -c '
  oid=$(psql -U nominatim -d nominatim --tuples-only --no-align --command "SELECT oid FROM pg_database WHERE datname=current_database();")
  datadir=$(psql -U nominatim -d nominatim --tuples-only --no-align --command "SHOW data_directory;")
  echo "pgroonga_index_size=$(du --total -h "$datadir/base/$oid"/pgrn* 2>/dev/null | tail -1 | cut -f1)"
'
