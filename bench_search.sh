#!/usr/bin/bash

query="${1:-広島平和記念資料館}"
count="${2:-10}"

echo "query=${query} runs=${count}"

docker compose exec -T db psql -U nominatim -d nominatim --command \
  "SELECT count(*) FROM search_name;"

docker compose exec -T db psql -U nominatim -d nominatim --command \
  "EXPLAIN SELECT place_id FROM search_name WHERE all_names &@ '${query}';"

for i in $(seq 1 "${count}"); do
  docker compose exec -T db psql -U nominatim -d nominatim --command \
    "EXPLAIN (ANALYZE) SELECT place_id FROM search_name WHERE all_names &@ '${query}';" \
    | grep "Execution Time"
done
