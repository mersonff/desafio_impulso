FROM ruby:3.2.2

ENV BUNDLER_VERSION='2.4.22'

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y vim\
        curl \
        build-essential \
        libpq-dev \
        postgresql-client \
        redis-server \
        libsqlite3-dev \
        sqlite3 \
        nodejs \
        yarn

WORKDIR /desafio_impulso

COPY . ./

RUN gem install bundler -v $BUNDLER_VERSION \
  && bundle config build.nokogiri --use-system-libraries \
  && bundle config set --local without 'production' \
  && bundle install

RUN yarn install --check-files

EXPOSE 3333
