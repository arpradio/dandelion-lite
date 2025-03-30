FROM postgres:16.1-bullseye

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt to automatically select the default option for config file prompts
RUN echo 'Dpkg::Options {"--force-confdef"; "--force-confold";}' > /etc/apt/apt.conf.d/local

# Install required dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        make \
        postgresql-server-dev-all \
        libcurl4-openssl-dev \
        clang \
        ca-certificates

# Clone and build pg_curl extension
RUN git clone https://github.com/RekGRpth/pg_curl.git /tmp/pg_curl
COPY Makefile /tmp/pg_curl/Makefile
RUN cd /tmp/pg_curl && \
    make && \
    make install

# Clean up
RUN apt-get remove -y git make postgresql-server-dev-all clang && \
    apt-get autoremove --purge -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/pg_curl

# Create a script to enable extensions when the database is initialized
RUN mkdir -p /docker-entrypoint-initdb.d
RUN echo "-- Extensions initialization script" > /docker-entrypoint-initdb.d/10_extensions.sql
# Uncomment the next line if you want pg_curl available to all users
# RUN echo "CREATE EXTENSION IF NOT EXISTS pg_curl;" >> /docker-entrypoint-initdb.d/10_extensions.sql

# Use postgres as the default command
CMD ["postgres"]
