# Still start from Judge0
FROM judge0/compilers:1.4.0 AS production

# Patch sources (because Debian Stretch is archived)
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

# Install dependencies and Ruby (replace 3.2.2 with latest version if needed)
RUN apt-get update && \
    apt-get install -y wget build-essential libssl-dev libreadline-dev zlib1g-dev && \
    wget https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.2.tar.gz && \
    tar -xzvf ruby-3.2.2.tar.gz && \
    cd ruby-3.2.2 && ./configure && make && make install && \
    cd .. && rm -rf ruby-3.2.2 ruby-3.2.2.tar.gz && \
    gem install bundler

# ✅ Install system packages + Ruby + Bundler
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      cron \
      libpq-dev \
      sudo \
      ruby-full \
      build-essential && \
    gem install bundler && \
    rm -rf /var/lib/apt/lists/*

EXPOSE 2358

WORKDIR /api

COPY Gemfile* ./
RUN RAILS_ENV=production bundle install --without development test

COPY cron /etc/cron.d
RUN cat /etc/cron.d/* | crontab -

COPY . .

RUN chmod +x /api/docker-entrypoint.sh /api/scripts/server

ENTRYPOINT ["/api/docker-entrypoint.sh"]
CMD ["/api/scripts/server"]

RUN useradd -u 1000 -m -r judge0 && \
    echo "judge0 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chown judge0: /api/tmp/

USER judge0

ENV JUDGE0_VERSION "1.13.1"
LABEL version=$JUDGE0_VERSION

FROM production AS development
CMD ["sleep", "infinity"]
