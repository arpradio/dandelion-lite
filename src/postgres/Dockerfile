# Dockerfile to install these extensions to PostgresDB
# Extensions: pg_curl,pg_cardano

FROM postgres:16.1-bullseye
#FROM postgres:16.8-bullseye

# 1) install build tools & libs
RUN apt-get update && apt-get -y install git make build-essential curl sudo

# 2) build & install pg_curl
RUN apt-get update && apt-get -y install postgresql-server-dev-16 libcurl-ocaml-dev clang curl sudo
RUN git clone https://github.com/RekGRpth/pg_curl.git
COPY pg_curl/Makefile pg_curl/Makefile
RUN cd pg_curl && make && make install


# 3) download, unpack & install pg_cardano v1.0.5-p2
# ARG PG_CARDANO_VERSION=v1.0.5-p2
# RUN curl -sL \
#       https://github.com/cardano-community/pg_cardano/releases/download/${PG_CARDANO_VERSION}/pg_cardano_linux_x64_${PG_CARDANO_VERSION}.tar.gz \
#     | tar xz -C /tmp \
#  && cd /tmp/pg_cardano\
#  && chmod +x install.sh \
#  && ./install.sh


# 2) Install Rust toolchain non-interactively:
ENV RUSTUP_HOME=/usr/local/rustup \
        CARGO_HOME=/usr/local/cargo \
        PATH=/usr/local/cargo/bin:$PATH 

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
        | sh -s -- -y --default-toolchain stable
        
# 3) Clone, build & install pg_cardano:
ARG PG_CARDANO_VERSION=v1.0.5-p2
RUN apt-get update && apt-get -y install libclang-dev libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc ccache pkg-config
RUN git clone --branch ${PG_CARDANO_VERSION} --depth 1 \
        https://github.com/cardano-community/pg_cardano.git /tmp/pg_cardano
# COPY pg_cardano/cargo.toml /tmp/pg_cardano/
RUN  cd /tmp/pg_cardano \
        && cargo install cargo-pgrx --version 0.12.9 --locked \
        && cargo pgrx init \
        && cargo pgrx package \
        && cargo pgrx install --release --sudo 

# clean up source & caches in one go:
RUN cd / \
        && rm -rf /tmp/pg_cardano \
                $RUSTUP_HOME \
                $CARGO_HOME 


#4)  cleanup build-time packages and temp files
 RUN cd / && \
        rm -rf /pg_curl && \
        export SUDO_FORCE_REMOVE=yes && \
        apt-get remove -y git make postgresql-server-dev-16 clang curl sudo && \
        apt-get autoremove --purge -y && \
        apt-get clean && \
        apt-get purge && \
        rm -rf /tmp/* /var/lib/apt/lists/*

# 5) Extensions should be managed with private schemas, out from untrusted user's scope. Uncomment if you know what you are doing:to allow them for everybody.
# RUN echo "CREATE EXTENSION IF NOT EXISTS pg_curl ;" >> /docker-entrypoint-initdb.d/10_extensions.sql
# RUN echo "CREATE EXTENSION IF NOT EXISTS pg_cardano ;" >> /docker-entrypoint-initdb.d/10_extensions.sql
CMD ["bash"]




