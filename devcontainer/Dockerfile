FROM registry.fedoraproject.org/fedora:42

ARG NODE_VERSION=24.1.0
ARG PNPM_VERSION=10.11.0

RUN dnf install -yq zsh micro git tig iputils make awk psmisc procps-ng \
  openssh-server \
  && dnf clean all \
  && rm -rf /var/cache/dnf

RUN mkdir -p /var/run/sshd \
  && ssh-keygen -A \
  && sed -i 's/^#?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config \
  && sed -i 's/^#?PermitRootLogin .*/PermitRootLogin prohibit-password/' /etc/ssh/sshd_config \
  && sed -i 's/^#?PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
  && sed -i 's/^#?ChallengeResponseAuthentication .*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config

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

RUN useradd -s /bin/zsh ai
# On first run comment all commands below, run zsh and call:
# chown ai:ai /home/ai/.local/share/pnpm/store
USER ai

RUN  mkdir -p /home/ai/.local/share/node \
  && mkdir -p /home/ai/.local/share/pnpm \
  && pnpm config set store-dir /home/ai/.local/share/pnpm/store

VOLUME /home/ai/.local/share/pnpm/store
VOLUME /home/ai/.shell-history
