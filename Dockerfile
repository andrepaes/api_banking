FROM elixir:1.10

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
	&& apt-get install -y locales inotify-tools postgresql-client \
    && rm -rf /var/cache/apt \
    && mix local.hex --force \
    && mix local.rebar --force \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen