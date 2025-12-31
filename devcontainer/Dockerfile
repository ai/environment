FROM registry.fedoraproject.org/fedora:43

ENV NODE_VERSION=25.2.1 \
  PNPM_VERSION=10.27.0 \
  NODE_24=24.11.1 \
  NODE_22=22.21.1 \
  NODE_20=20.19.5 \
  DIFFT_VERSION=0.65.0 \
  BAT_VERSION=0.26.0 \
  RG_VERSION=15.1.0 \
  ATUIN_VERSION=18.10.0 \
  STARSHIP_VERSION=1.24.1 \
  PNPM_COMPETITION_VERSION=0.5.5

RUN dnf install -yq zsh micro git tig make awk psmisc procps-ng curl \
  openssh-server bind-utils iputils iproute libatomic nss dbus-libs atk \
  at-spi2-atk cups-libs libdrm libXcomposite libXdamage libXrandr mesa-libgbm \
  pango alsa-lib \
  && dnf clean all \
  && rm -rf /var/cache/dnf \
  && mkdir -p /var/run/sshd \
  && ssh-keygen -A

ADD https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz /node.tar.xz
ADD https://nodejs.org/dist/v${NODE_24}/node-v${NODE_24}-linux-x64.tar.gz /node24.tar.xz
ADD https://nodejs.org/dist/v${NODE_22}/node-v${NODE_22}-linux-x64.tar.gz /node22.tar.xz
ADD https://nodejs.org/dist/v${NODE_20}/node-v${NODE_20}-linux-x64.tar.gz /node20.tar.xz
ADD https://github.com/pnpm/pnpm/releases/download/v$PNPM_VERSION/pnpm-linux-x64 /usr/local/bin/pnpm
ADD https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-musl.tar.gz /eza.tar.gz
ADD https://github.com/Wilfred/difftastic/releases/download/$DIFFT_VERSION/difft-x86_64-unknown-linux-musl.tar.gz /difft.tar.gz
ADD https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-x86_64-unknown-linux-musl.tar.gz /bat.tar.gz
ADD https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz /rg.tar.gz
ADD https://github.com/atuinsh/atuin/releases/download/v$ATUIN_VERSION/atuin-x86_64-unknown-linux-musl.tar.gz /atuin.tar.gz
ADD https://github.com/starship/starship/releases/download/v$STARSHIP_VERSION/starship-x86_64-unknown-linux-musl.tar.gz /starship.tar.gz
ADD https://github.com/g-plane/pnpm-shell-completion/releases/download/v$PNPM_COMPETITION_VERSION/pnpm-shell-completion_x86_64-unknown-linux-musl.tar.gz /pnpm-completion.tar.gz

RUN chmod a+rx /usr/local/bin/pnpm \
  \
  && tar -xz -f /node.tar.xz -C /usr/local --remove-files --strip-components=1 \
  --exclude='*.md' --exclude='LICENSE' \
  --exclude='share' --exclude='bin/corepack' \
  && rm /node.tar.xz \
  \
  && tar -xzf /node24.tar.xz -O "node-v$NODE_24-linux-x64/bin/node" > /usr/local/bin/node24 \
  && tar -xzf /node22.tar.xz -O "node-v$NODE_22-linux-x64/bin/node" > /usr/local/bin/node22 \
  && tar -xzf /node20.tar.xz -O "node-v$NODE_20-linux-x64/bin/node" > /usr/local/bin/node20 \
  && chmod a+rx /usr/local/bin/node24 \
  && chmod a+rx /usr/local/bin/node22 \
  && chmod a+rx /usr/local/bin/node20 \
  \
  && npm install -g yarn bun \
  \
  && tar -xz -f /eza.tar.gz \
  && mv eza /usr/local/bin/eza \
  && chmod +x /usr/local/bin/eza \
  && rm /eza.tar.gz \
  \
  && tar -xz -f /difft.tar.gz \
  && mv difft /usr/local/bin/difft \
  && chmod +x /usr/local/bin/difft \
  && rm /difft.tar.gz \
  \
  && tar -xz -f /bat.tar.gz --strip-components=1 bat-v$BAT_VERSION-x86_64-unknown-linux-musl/bat \
  && mv bat /usr/local/bin/bat \
  && chmod +x /usr/local/bin/bat \
  && rm /bat.tar.gz \
  \
  && tar -xz -f /rg.tar.gz --strip-components=1 ripgrep-$RG_VERSION-x86_64-unknown-linux-musl/rg \
  && mv rg /usr/local/bin/rg \
  && chmod +x /usr/local/bin/rg \
  && rm /rg.tar.gz \
  \
  && tar -xz -f /atuin.tar.gz --strip-components=1 atuin-x86_64-unknown-linux-musl/atuin \
  && mv atuin /usr/local/bin/atuin \
  && chmod +x /usr/local/bin/atuin \
  && rm /atuin.tar.gz \
  \
  && tar -xz -f /starship.tar.gz \
  && mv starship /usr/local/bin/starship \
  && chmod +x /usr/local/bin/starship \
  && rm /starship.tar.gz \
  \
  && mkdir -p /usr/local/lib/zsh \
  && git clone -q https://github.com/zsh-users/zsh-syntax-highlighting /usr/local/lib/zsh/zsh-syntax-highlighting \
  && git clone https://github.com/zsh-users/zsh-autosuggestions /usr/local/lib/zsh/zsh-autosuggestions \
  && git clone https://github.com/jimhester/per-directory-history /usr/local/lib/zsh/per-directory-history \
  && mkdir -p /usr/local/lib/zsh/pnpm-shell-completion \
  && tar -xz -f /pnpm-completion.tar.gz -C /usr/local/lib/zsh/pnpm-shell-completion pnpm-shell-completion pnpm-shell-completion.plugin.zsh \
  && chmod a+x /usr/local/lib/zsh/pnpm-shell-completion/pnpm-shell-completion \
  && rm /pnpm-completion.tar.gz \
  \
  && useradd -s /bin/zsh ai

USER ai

RUN micro -plugin install editorconfig \
  && mkdir -p /home/ai/.local/share/pnpm/ \
  && pnpm config set store-dir /home/ai/.local/share/pnpm/store \
  && pnpm config --global set minimumReleaseAge 1440 \
  && pnpm config --global set blockExoticSubdeps true \
  && pnpm config --global set trustPolicy "no-downgrade" \
  && pnpm config --global set trustPolicyIgnoreAfter 43200

VOLUME /home/ai/.local/share/pnpm/store
VOLUME /home/ai/.shell-history
