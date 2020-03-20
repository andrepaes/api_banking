# Use an official Elixir runtime as a parent image
FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client \
  apt-get install -y build-essential \
  apt-get install -y
RUN mkdir /app

RUN mix local.hex --force

RUN mix local.rebar --force