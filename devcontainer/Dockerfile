FROM registry.fedoraproject.org/fedora:40

ARG NODE_VERSION=22.1.0
ARG PNPM_VERSION=9.1.1

RUN dnf install -yq 'dnf-command(copr)' && \
  dnf copr enable -yq atim/starship && \
  dnf update -qy && \
  dnf install -yq starship zsh eza bat micro git tig ripgrep iputils

RUN useradd -s /bin/zsh ai
USER ai

RUN git clone -q https://github.com/zsh-users/zsh-syntax-highlighting \
  ~/.zsh/zsh-syntax-highlighting
RUN git clone -q https://github.com/zsh-users/zsh-history-substring-search \
  ~/.zsh/zsh-history-substring-search

COPY --chown=ai:ai gitconfig /home/ai/.gitconfig
COPY --chown=ai:ai ripgreprc /home/ai/.ripgreprc
COPY --chown=ai:ai micro.json /home/ai/.config/micro/settings.json
COPY --chown=ai:ai batconfig /home/ai/.config/bat/config
COPY --chown=ai:ai starship.toml /home/ai/.config/starship.toml
COPY --chown=ai:ai zshrc /home/ai/.zshrc
COPY --chown=ai:ai gitignore /home/ai/.config/git/ignore

RUN micro -plugin install editorconfig
RUN curl -fsSL https://git.io/antigen > /home/ai/.antigen.zsh

ENV PNPM_HOME /home/ai/.local/share/pnpm
ENV PATH $PNPM_HOME:$PATH
RUN mkdir -p /home/ai/.local/share/pnpm/ && \
  curl -fsSL https://github.com/pnpm/pnpm/releases/download/v$PNPM_VERSION/pnpm-linux-x64 > /home/ai/.local/share/pnpm/pnpm && \
  chmod a+x /home/ai/.local/share/pnpm/pnpm && \
  echo 'export PNPM_HOME="/home/ai/.local/share/pnpm"' >> /home/ai/.zshrc && \
  echo 'export PATH=$PNPM_HOME:$PATH' >> /home/ai/.zshrc && \
  pnpm config set ignore-scripts false && \
  pnpm config set store-dir /home/ai/.local/share/pnpm/store
RUN pnpm env use --global $NODE_VERSION
RUN mkdir -p /home/ai/.local/share/node && \
  pnpm install -s --dir /home/ai/.local/share/node typescript

VOLUME /home/ai/.local/share/pnpm/store
