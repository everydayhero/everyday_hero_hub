FROM ruby:2.1.5
MAINTAINER EverydayHero "edh-dev@everydayhero.com.au"

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install --frozen

ENV APPDIR=/usr/src/app

RUN mkdir -p $APPDIR
WORKDIR $APPDIR

COPY serve /serve

COPY . $APPDIR

ENV PORT 8080

CMD ["/serve"]
