FROM registry.fedoraproject.org/fedora:43

ARG NODE_VERSION=25.1.0
ARG PNPM_VERSION=10.21.0
ARG NODE_24=24.11.0
ARG NODE_22=22.21.1
ARG NODE_20=20.19.5

RUN dnf install -yq zsh micro git tig make awk psmisc procps-ng \
  openssh-server bind-utils iputils iproute libatomic \
  && dnf clean all \
  && rm -rf /var/cache/dnf \
  && mkdir -p /var/run/sshd \
  && ssh-keygen -A

ADD https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz /node.tar.xz
ADD https://nodejs.org/dist/v${NODE_24}/node-v${NODE_24}-linux-x64.tar.gz /node24.tar.xz
ADD https://nodejs.org/dist/v${NODE_22}/node-v${NODE_22}-linux-x64.tar.gz /node22.tar.xz
ADD https://nodejs.org/dist/v${NODE_20}/node-v${NODE_20}-linux-x64.tar.gz /node20.tar.xz
ADD https://github.com/pnpm/pnpm/releases/download/v$PNPM_VERSION/pnpm-linux-x64 /usr/local/bin/pnpm
RUN tar -xz -f /node.tar.xz -C /usr/local --remove-files --strip-components=1 \
  --exclude='*.md' --exclude='LICENSE' \
  --exclude='share' --exclude='bin/corepack' \
  && tar -xzf /node24.tar.xz -O "node-v$NODE_24-linux-x64/bin/node" > /usr/local/bin/node24 \
  && tar -xzf /node22.tar.xz -O "node-v$NODE_22-linux-x64/bin/node" > /usr/local/bin/node22 \
  && tar -xzf /node20.tar.xz -O "node-v$NODE_20-linux-x64/bin/node" > /usr/local/bin/node20 \
  && chmod a+rx /usr/local/bin/node24 \
  && chmod a+rx /usr/local/bin/node22 \
  && chmod a+rx /usr/local/bin/node20 \
  && rm /node.tar.xz \
  && chmod a+rx /usr/local/bin/pnpm \
  && npm install -g yarn bun \
  && useradd -s /bin/zsh ai

USER ai

RUN mkdir -p /home/ai/.local/share/pnpm/ \
  && pnpm config set store-dir /home/ai/.local/share/pnpm/store \
  && pnpm config --global set minimumReleaseAge 1440 \
  && pnpm config --global set trustPolicy no-downgrade

VOLUME /home/ai/.local/share/pnpm/store
VOLUME /home/ai/.shell-history
