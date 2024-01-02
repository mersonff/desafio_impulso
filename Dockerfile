FROM ruby:3.2.2

ENV BUNDLER_VERSION='2.4.22'

RUN apt-get update -qq && apt-get install -y vim\
        curl \
        build-essential \
        libpq-dev \
        postgresql-client \
        redis-server \
        libsqlite3-dev \
        sqlite3

WORKDIR /desafio_impulso

COPY . ./

RUN gem install bundler -v $BUNDLER_VERSION \
  && gem install mailcatcher \
  && bundle config build.nokogiri --use-system-libraries \
  && bundle config set --local without 'production' \
  && bundle install

EXPOSE 3333
