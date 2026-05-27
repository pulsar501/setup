FROM docker.io/library/ubuntu:24.04

ENV TZ=Europe/Berlin \
    DEBIAN_FRONTEND=noninteractive \
    USER=p \
    HOME=/home/p \
    XDG_CONFIG_HOME=/home/p/.config \
    XDG_CACHE_HOME=/home/p/.cache \
    XDG_DATA_HOME=/home/p/.local/share \
    XDG_STATE_HOME=/home/p/.local/state \
    PATH="/home/p/.local/bin:/home/p/.local/share/mise/shims:$PATH"

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
      curl git zsh bash stow ca-certificates sudo tzdata && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*

ARG PASS=p
RUN useradd -ms /bin/bash $USER && \
    echo "${USER}:${PASS}" | chpasswd && \
    echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $USER

RUN curl -fsSL https://mise.run | sh

COPY --chown=$USER docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR $HOME
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bats", ".dotfiles/tests/"]
