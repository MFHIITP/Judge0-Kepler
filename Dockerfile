FROM judge0/compilers:1.4.0 AS production

# 🩹 Patch Debian sources
RUN sed -i 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' /etc/apt/sources.list && \
    sed -i 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until

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
