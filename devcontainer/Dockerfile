FROM registry.fedoraproject.org/fedora:40

ARG NODE_VERSION=22.2.0
ARG PNPM_VERSION=9.1.1

RUN dnf install -yq 'dnf-command(copr)' && \
  dnf copr enable -yq atim/starship && \
  dnf update -qy && \
  dnf install -yq starship zsh eza bat micro git tig ripgrep iputils

RUN useradd -s /bin/zsh ai
USER ai

ENV PNPM_HOME /home/ai/.local/share/pnpm
ENV PATH $PNPM_HOME:$PATH
RUN mkdir -p $PNPM_HOME && \
  curl -fsSL https://github.com/pnpm/pnpm/releases/download/v$PNPM_VERSION/pnpm-linux-x64 > $PNPM_HOME/pnpm && \
  chmod a+x $PNPM_HOME/pnpm && \
  pnpm config set ignore-scripts false && \
  pnpm config set store-dir /home/ai/.local/share/pnpm/store
RUN pnpm env use --global $NODE_VERSION
RUN mkdir -p /home/ai/.local/share/node && \
  pnpm install -s --dir /home/ai/.local/share/node typescript

VOLUME /home/ai/.local/share/pnpm/store
VOLUME /home/ai/.shell-history
