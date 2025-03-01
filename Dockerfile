# Dockerfile
# Building for production

FROM elixir:1.18.2-alpine as build

RUN mkdir -p /opt/app

COPY . /opt/app
WORKDIR /opt/app

ENV MIX_ENV=prod

RUN apk --no-cache --update add \
  g++ \
  gcc \
  git \
  libc-dev \
  make \
  nodejs \
  npm \
  python3

RUN cd /opt/app && \
  mix local.hex --force && \
  mix local.rebar --force && \
  mix deps.get

RUN npm install npm -g --no-progress && \
  npm --prefix assets ci && \
  mix assets.deploy

RUN mix phx.gen.release
RUN mix release

# Dockerfile
# Running in production

FROM elixir:1.18.2-alpine as release

RUN apk add --no-cache bash openssl

RUN mkdir -p /opt/app

COPY --from=build /opt/app/_build/prod/rel/store /opt/app

WORKDIR /opt/app

EXPOSE 4000

ENTRYPOINT ["/opt/app/bin/server"]
