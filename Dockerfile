FROM ruby:2.7.5-alpine
ENV BUNDLER_VERSION=2.3.10

RUN apk add --no-cache sqlite-libs
RUN apk add --update --virtual \
  runtime-deps \
  build-base \
  libxml2-dev \
  libxslt-dev \
  yarn \
  build-base \
  libc-dev \
  git \
  tzdata \
  python3 \
  openssh-client \
  sqlite-dev \
  && rm -rf /var/cache/apk/*

# TODO: This should use multi-stage builds
#'yum install sqlite-devel' or 'apt-get install libsqlite3-dev'

WORKDIR /app

ENV BUNDLE_PATH /gems
RUN gem install bundler -v 2.3.10
#COPY package.json yarn.lock ./
#RUN yarn install


COPY Gemfile Gemfile.lock ./
RUN bundle config build.nokogiri --use-system-libraries
#RUN ssh-keyscan github.com >> ~/.ssh/known_hosts
RUN bundle check || bundle install
# Steps above could be cached most of the time when re-building image
# RUN bundle exec rails db:migrate RAILS_ENV=development
# RUN bundle exec rails db:seed

 # Copy source code after dependencies installed
COPY . ./

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
