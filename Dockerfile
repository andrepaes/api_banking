# Use an official Elixir runtime as a parent image
FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix local.hex --force

RUN mix local.rebar --force

RUN mix deps.get

CMD ["/app/run.sh"]