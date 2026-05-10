FROM ubuntu:24.04

ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

RUN apt update
RUN apt install -y -V \
  build-essential \
  ca-certificates \
  git \
  libicu-dev \
  osm2pgsql \
  osmium-tool \
  pkg-config \
  python3 \
  python3-dev \
  python3-venv \
  wget

RUN git clone -b pgroonga https://github.com/abetomo/Nominatim.git /nominatim/src

RUN wget -O /nominatim/src/data/country_osm_grid.sql.gz \
  https://nominatim.org/data/country_grid.sql.gz

RUN python3 -m venv /nominatim/venv
RUN /nominatim/venv/bin/pip install --no-cache-dir --upgrade pip
RUN /nominatim/venv/bin/pip install --no-cache-dir "psycopg[binary]"
RUN /nominatim/venv/bin/pip install --no-cache-dir falcon uvicorn gunicorn
RUN /nominatim/venv/bin/pip install --no-cache-dir \
  /nominatim/src/packaging/nominatim-db \
  /nominatim/src/packaging/nominatim-api

ENV PATH="/nominatim/venv/bin:$PATH"

RUN mkdir -p /nominatim/project
WORKDIR /nominatim/project
