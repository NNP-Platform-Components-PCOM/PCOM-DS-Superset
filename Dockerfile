# syntax=docker/dockerfile:1.7
#
# PCOM-DS-Superset
# Pinned upstream image (apache/superset:6.0.0) republished under the NNP Data Store namespace.

FROM apache/superset:6.0.0

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION="6.0.0"

LABEL org.opencontainers.image.title="pcom-ds-superset" \
      org.opencontainers.image.description="NNP Data Store component: superset" \
      org.opencontainers.image.vendor="Nubo Native Platform" \
      org.opencontainers.image.source="https://github.com/NNP-Platform-Components-PCOM/PCOM-DS-Superset" \
      org.opencontainers.image.url="https://github.com/NNP-Platform-Components-PCOM/PCOM-DS-Superset" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.revision="${VCS_REF}" \
      org.opencontainers.image.created="${BUILD_DATE}"

USER root

ENV UV_CACHE_DIR=/tmp/uv-cache

RUN apt-get update && apt-get install -y --no-install-recommends \
    pkg-config \
    build-essential \
    default-libmysqlclient-dev \
    && apt-get clean

RUN mkdir -p /tmp/uv-cache && \
    chown -R superset:superset /tmp/uv-cache /app/.venv

USER superset

RUN . /app/.venv/bin/activate && \
    uv pip install \
        psycopg2-binary \
        pymssql \
        Authlib \
        openpyxl \
        Pillow \
        pyhive \
        prophet \
        clickhouse-connect \
        mysqlclient \
        starrocks

CMD ["/app/docker/entrypoints/run-server.sh"]
