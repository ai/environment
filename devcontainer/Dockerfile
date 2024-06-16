FROM registry.fedoraproject.org/fedora:40

ARG NODE_VERSION=22.3.0
ARG PNPM_VERSION=9.3.0

RUN dnf update -yq \
  && dnf install -yq zsh eza bat micro git tig ripgrep iputils make

ADD https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz /node.tar.gz
RUN tar -xz -f /node.tar.gz -C /usr/local --remove-files --strip-components=1 \
  --exclude='*.md' --exclude='LICENSE' \
  --exclude='share' --exclude='bin/corepack'
ADD https://github.com/pnpm/pnpm/releases/download/v$PNPM_VERSION/pnpm-linux-x64 /usr/local/bin/pnpm
RUN chmod a+rx /usr/local/bin/pnpm
RUN ls -l /usr/local/bin/

RUN useradd -s /bin/zsh ai
USER ai

RUN pnpm config set ignore-scripts false \
  && pnpm config set store-dir /home/ai/.local/share/pnpm/store
RUN mkdir -p /home/ai/.local/share/node \
  && pnpm install -s --dir /home/ai/.local/share/node typescript

VOLUME /home/ai/.local/share/pnpm/store
VOLUME /home/ai/.shell-history
