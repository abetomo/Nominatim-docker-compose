FROM postgres:18-bookworm

RUN apt update
RUN apt install -y -V curl ca-certificates lsb-release wget

RUN apt install -y -V postgresql-${PG_MAJOR}-postgis-3 postgresql-${PG_MAJOR}-postgis-3-scripts

RUN wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb
RUN apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb
RUN apt update
RUN apt install -y -V postgresql-${PG_MAJOR}-pgdg-pgroonga
