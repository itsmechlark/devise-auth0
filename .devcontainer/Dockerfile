# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.191.1/containers/ruby/.devcontainer/base.Dockerfile

# [Choice] Ruby version: 3, 3.3, 3.2, 3.1, 3.0, 2, 2.7, 2.6
ARG VARIANT="2"
FROM mcr.microsoft.com/devcontainers/ruby:${VARIANT}

# Default value to allow debug server to serve content over GitHub Codespace's port forwarding service
# The value is a comma-separated list of allowed domains 
ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev"

# [Optional] Uncomment this section to install additional OS packages.
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        postgresql-client \
        postgresql-contrib \
        libpq-dev

# Install MongoDB Shell
ARG MONGOSH_VERSION="2.1.4"
RUN ARCH=$(dpkg --print-architecture) \
    && if [ "$ARCH" = "amd64" ] || [ "$ARCH" = "arm64" ]; then \
        wget -qO /tmp/mongosh.deb "https://downloads.mongodb.com/compass/mongodb-mongosh_${MONGOSH_VERSION}_${ARCH}.deb" \
        && apt-get install -y /tmp/mongosh.deb \
        && rm -rf /tmp/*; \
    fi

# Install supported Ruby versions
# https://www.ruby-lang.org/en/downloads/releases/
RUN /bin/bash -c "source /usr/local/rvm/scripts/rvm \
    && rvm install 2.7.8 \
    && rvm install 3.0.6 \
    && rvm install 3.1.4 \
    && rvm install 3.2.3 \
    && rvm install 3.3.0"

# Set the default bundle path
ENV BUNDLE_PATH=/usr/local/bundle

# Install gem dependencies
RUN mkdir -p /tmp/gem/lib/devise/auth0
COPY gemfiles /tmp/gem/gemfiles
COPY lib/devise/auth0/version.rb /tmp/gem/lib/devise/auth0
COPY Appraisals devise_auth0.gemspec Gemfile Gemfile.lock /tmp/gem/
RUN mkdir -p ${BUNDLE_PATH} \
    && gem install bundler:2.4.21 \
    && cd /tmp/gem \
    && bundle install --jobs=3 --retry=3 \
    && bundle exec appraisal install \
    && rm -rf /tmp/gem
VOLUME ["/usr/local/bundle"]

RUN chown -R vscode:vscode /usr/local/rvm ${BUNDLE_PATH}
