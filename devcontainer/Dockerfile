FROM registry.fedoraproject.org/fedora:42

ARG NODE_VERSION=24.8.0
ARG PNPM_VERSION=10.15.1

RUN dnf install -yq zsh micro git tig make awk psmisc procps-ng \
  openssh-server bind-utils iputils iproute \
  && dnf clean all \
  && rm -rf /var/cache/dnf \
  && mkdir -p /var/run/sshd \
  && ssh-keygen -A

ADD https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz /node.tar.xz
ADD https://github.com/pnpm/pnpm/releases/download/v$PNPM_VERSION/pnpm-linux-x64 /usr/local/bin/pnpm
RUN tar -xz -f /node.tar.xz -C /usr/local --remove-files --strip-components=1 \
  --exclude='*.md' --exclude='LICENSE' \
  --exclude='share' --exclude='bin/corepack' \
  && rm /node.tar.xz \
  && chmod a+rx /usr/local/bin/pnpm \
  && npm install -g yarn bun \
  && useradd -s /bin/zsh ai

USER ai

RUN mkdir -p /home/ai/.local/share/pnpm/ \
  && pnpm config set store-dir /home/ai/.local/share/pnpm/store \
  && pnpm config --global set minimum-release-age 1440

VOLUME /home/ai/.local/share/pnpm/store
VOLUME /home/ai/.shell-history
