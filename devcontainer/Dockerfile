FROM registry.fedoraproject.org/fedora:41

ARG NODE_VERSION=23.11.0
ARG PNPM_VERSION=10.8.0

RUN dnf update -yq \
  && dnf install -yq zsh eza bat micro git tig ripgrep iputils make \
  psmisc procps-ng difftastic \
  && dnf clean all \
  && rm -rf /var/cache/dnf

ADD https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz /node.tar.xz
RUN tar -xz -f /node.tar.xz -C /usr/local --remove-files --strip-components=1 \
  --exclude='*.md' --exclude='LICENSE' \
  --exclude='share' --exclude='bin/corepack' \
  && rm /node.tar.xz
ADD https://github.com/pnpm/pnpm/releases/download/v$PNPM_VERSION/pnpm-linux-x64 /usr/local/bin/pnpm
RUN chmod a+rx /usr/local/bin/pnpm
ADD https://github.com/suzuki-shunsuke/pinact/releases/download/v3.0.1/pinact_linux_amd64.tar.gz /pinact.tar.gz
RUN tar -xz -f /pinact.tar.gz -C /usr/local/bin --remove-files \
  --exclude='LICENSE' --exclude='*.md' \
  && rm /pinact.tar.gz

RUN npm install -g yarn && npm install -g bun

RUN useradd -s /bin/zsh ai \
  && mkdir -p /home/ai/.local/share/pnpm \
  && chown -R ai:ai /home/ai/
USER ai

RUN  pnpm config set store-dir /home/ai/.local/share/pnpm/store \
  && mkdir -p /home/ai/.local/share/node

VOLUME /home/ai/.local/share/pnpm/store
VOLUME /home/ai/.shell-history
