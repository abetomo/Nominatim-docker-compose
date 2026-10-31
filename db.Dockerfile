FROM postgres:18-trixie

RUN apt update
RUN apt install -y -V curl ca-certificates lsb-release wget

RUN apt install -y -V postgresql-${PG_MAJOR}-postgis-3 postgresql-${PG_MAJOR}-postgis-3-scripts

RUN wget https://packages.groonga.org/debian/groonga-apt-source-latest-$(lsb_release --codename --short).deb
RUN apt install -y -V ./groonga-apt-source-latest-$(lsb_release --codename --short).deb
RUN apt update
RUN apt install -y -V postgresql-${PG_MAJOR}-pgdg-pgroonga

# Work around Apache Arrow's missing OpenTelemetry runtime dependency.
# https://github.com/apache/arrow/issues/55112
RUN apt install -y -V opentelemetry-cpp
