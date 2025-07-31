# Base Judge0 image with all compilers
FROM judge0/compilers:1.4.0 AS base

# Install dependencies for cron, PostgreSQL, Node.js, etc.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      cron \
      libpq-dev \
      sudo \
      curl \
      gnupg \
      ruby-full \
      build-essential && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g --unsafe-perm aglio@2.3.0 && \
    gem install bundler && \
    rm -rf /var/lib/apt/lists/*

# Setup environment
ENV GEM_HOME="/opt/.gem"
ENV PATH="/opt/.gem/bin:$PATH"

# Set working directory
WORKDIR /api

# Copy Gemfile and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Set up cron jobs
COPY cron /etc/cron.d
RUN cat /etc/cron.d/* | crontab -

# Copy remaining project files
COPY . .

# Expose API port
EXPOSE 2358

# Fix permissions and setup judge0 user
RUN useradd -u 1000 -m -r judge0 && \
    echo "judge0 ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
    chown judge0: /api/tmp/

# Switch to non-root user
USER judge0

# Labels
LABEL maintainer="Herman Zvonimir Došilović <hermanz.dosilovic@gmail.com>"
ENV JUDGE0_VERSION="1.13.1"

# Start the app
ENTRYPOINT ["/api/docker-entrypoint.sh"]
CMD ["/api/scripts/server"]
