FROM ruby:2.6.1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/Bookreview
COPY Gemfile* ./
RUN bundle install
COPY . .

ENV RAILS_VERSION 5.2.3

RUN gem install rails --version "$RAILS_VERSION"

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]