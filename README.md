# Nominatim-docker-compose

## Clone the repository

```bash
git clone https://github.com/abetomo/Nominatim-docker-compose.git
cd Nominatim-docker-compose
```

## Demo: PGroonga

### Setup

```bash
./setup.sh
```

Setup takes a while.

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

## Demo: Penalty tuning for CJ(K)

### Setup

```bash
NOMINATIM_BRANCH=penalty-tuning-for-cjk ./setup.sh
```

Setup takes a while.

### Without the tuning: not found

```bash
docker compose exec -e NOMINATIM_CJK_PENALTY=off nominatim \
  nominatim search --query "北海道大学付属図書館"
```

### With the tuning: found

```bash
docker compose exec -e NOMINATIM_CJK_PENALTY=on nominatim \
  nominatim search --query "北海道大学付属図書館"
```
