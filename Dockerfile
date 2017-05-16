# Use the barebones version of Ruby 2.2.3.
FROM ruby:2.2.3-slim

# Optionally set a maintainer name to let people know who made this image.
MAINTAINER Keaton Burleson <keaton.burleson@gmail.com>

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential nodejs libpq-dev

ENV INSTALL_PATH /Heat
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./


RUN bundle install --binstubs
COPY . .

RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://heat:reviveit@127.0.0.1/heat SECRET_TOKEN=dummytoken assets:precompile
VOLUME ["$INSTALL_PATH/public"]


CMD puma -p 3030
