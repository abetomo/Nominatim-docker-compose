# Nominatim-docker-compose

## Setup

```bash
git clone https://github.com/abetomo/Nominatim-docker-compose.git
cd Nominatim-docker-compose
./setup.sh
```

Setup takes a while.

## Demo

### Without PGroonga: not found

```bash
docker compose exec -e NOMINATIM_PGROONGA=off nominatim \
  nominatim search --query "広島平和記念資料館"
```

### With PGroonga: found

```bash
docker compose exec nominatim \
  nominatim search --query "広島平和記念資料館"
```
