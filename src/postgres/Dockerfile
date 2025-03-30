FROM postgres:16.1-bullseye

# Set non-interactive mode for apt to prevent prompts
ENV DEBIAN_FRONTEND=noninteractive

# Force apt to always keep local config files
RUN echo 'Dpkg::Options {"--force-confold";}' > /etc/apt/apt.conf.d/local

RUN apt-get update && apt-get -y install git make postgresql-server-dev-all libcurl-ocaml-dev clang 
RUN git clone https://github.com/RekGRpth/pg_curl.git
COPY Makefile pg_curl/Makefile
RUN cd pg_curl && make && make install
RUN cd / && \
        rm -rf /pg_cron && \
        apt-get remove -y git make postgresql-server-dev-all clang && \
        apt-get autoremove --purge -y && \
        apt-get clean && \
        apt-get purge
# Extensions should be managed with private schemas, out from untrusted user's scope. Uncomment if you know what you are doing:to allow pg_curl for everybody.
# RUN echo "CREATE EXTENSION IF NOT EXISTS pg_curl ;" >> /docker-entrypoint-initdb.d/10_extensions.sql
CMD ["bash"]
