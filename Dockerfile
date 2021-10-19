FROM rust:1.55 AS build

RUN echo "Installing build dependencies" \
    && apt-get update \
    && apt-get install -y libpq-dev libssl-dev pkg-config

ARG SQLX_VERSION=0.5.9

RUN echo "Installing sqlx-cli" \
    && cargo install sqlx-cli --no-default-features --features postgres --version $SQLX_VERSION

FROM debian:bullseye-slim

RUN echo "Installing runtime dependencies" \
    && apt-get update \
    && apt-get install -y libssl-dev libpq-dev postgresql-client-13 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

COPY --from=build /usr/local/cargo/bin/sqlx /usr/local/bin/sqlx
COPY ./wait-for-postgres.sh /usr/local/bin/wait-for-postgres.sh

RUN useradd --create-home app
USER app

WORKDIR /home/app
RUN mkdir /home/app/migrations

ENTRYPOINT ["wait-for-postgres.sh", "sqlx"]
CMD ["database", "setup"]

