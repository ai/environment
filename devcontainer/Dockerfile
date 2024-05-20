FROM registry.fedoraproject.org/fedora:40

ARG NODE_VERSION=22.2.0
ARG PNPM_VERSION=9.1.1
ARG NODE_CHECKSUM=sha256:2c6eaf8bfd0f886ed8764ffce19c795e909639105e4056b1d9f8f917bad12cf1
ARG PNPM_CHECKSUM=sha256:bb187b5c2d937e4389983fb4d79a7dbabbaf320cafd4a93e1c8f4da6dc60fb30

RUN dnf update -yq && dnf install -yq zsh eza bat micro git tig ripgrep iputils

ADD --checksum=$NODE_CHECKSUM https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz /node.tar.gz
RUN tar -xz -f /node.tar.gz -C /usr/local --remove-files --strip-components=1 \
  --exclude='*.md' --exclude='LICENSE' \
  --exclude='share' --exclude='lib/node_modules/' \
  --exclude='bin/npm' --exclude='bin/npx' --exclude='bin/corepack'
ADD --checksum=$PNPM_CHECKSUM https://github.com/pnpm/pnpm/releases/download/v$PNPM_VERSION/pnpm-linux-x64 /usr/local/bin/pnpm
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
