FROM ruby:3.4-alpine AS builder

RUN apk add --no-cache build-base nodejs yarn tzdata

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
ENV RAILS_ENV=production \
    SECRET_KEY_BASE=dummy \
    DATABASE_URL=sqlite3:///dev/null
RUN SECRET_KEY_BASE=dummy rails assets:precompile
RUN SECRET_KEY_BASE=dummy rails tailwindcss:build

FROM ruby:3.4-alpine

RUN apk add --no-cache nodejs tzdata sqlite-libs

WORKDIR /app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

EXPOSE 3000

ENV RAILS_ENV=production \
    PORT=3000 \
    RAILS_LOG_TO_STDOUT=true

CMD ["sh", "-c", "bin/rails db:migrate && bin/rails server -b 0.0.0.0"]
