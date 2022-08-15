# SPDX-FileCopyrightText: 2021 Rosa Richter
#
# SPDX-License-Identifier: MIT


VERSION 0.6

ARG MIX_ENV=dev
ARG ELIXIR_VERSION=1.13

all:
  BUILD +lint
  BUILD +lint-copyright
  BUILD +test \
    --ELIXIR_VERSION=1.14 \
    --ELIXIR_VERSION=1.13 \
    --ELIXIR_VERSION=1.12 \
    --ELIXIR_VERSION=1.11

get-deps:
  FROM elixir:${ELIXIR_VERSION}-alpine
  RUN mix do local.rebar --force, local.hex --force
  COPY mix.exs .
  COPY mix.lock .

  RUN mix deps.get

  SAVE ARTIFACT deps AS LOCAL ./deps

compile-deps:
  FROM +get-deps
  RUN MIX_ENV=$MIX_ENV mix deps.compile

  SAVE ARTIFACT _build/$MIX_ENV AS LOCAL ./_build/$MIX_ENV

build:
  FROM +compile-deps

  COPY priv ./priv
  COPY lib ./lib

  RUN MIX_ENV=$MIX_ENV mix compile

  SAVE ARTIFACT _build/$MIX_ENV AS LOCAL ./_build/$MIX_ENV

lint:
  FROM +build

  RUN MIX_ENV=$MIX_ENV mix credo list

lint-copyright:
  FROM fsfe/reuse

  COPY . .

  RUN reuse lint

lint-licenses:
  FROM +build

  RUN mix hex.licenses --reuse

test:
  FROM --build-arg MIX_ENV=test +build

  COPY test ./test

  RUN MIX_ENV=test mix test
