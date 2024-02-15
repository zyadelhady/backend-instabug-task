FROM ruby:3.2.0

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev nodejs

WORKDIR /app

RUN gem install bundler

COPY Gemfile* ./

RUN bundle install

COPY . .


EXPOSE 3000

# CMD [ "rails","server" ]
ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
