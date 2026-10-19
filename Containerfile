FROM registry.fedoraproject.org/fedora:latest

# Node.js (for Claude Code), git, and common command-line tools
# Add more tools to this line and rebuild: podman build -t claude-box .
RUN dnf install -y \
      nodejs npm git \
      jq ripgrep fd-find tree unzip which less \
    && dnf clean all

# uv (manages Python versions and project environments)
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

# Claude Code
RUN npm install -g @anthropic-ai/claude-code

# Non-root user with the same UID as your host user (check with: id -u)
RUN useradd -m -u 1000 dev
USER dev
WORKDIR /work

# Update Claude Code by rebuilding the image instead of self-updating
ENV DISABLE_AUTOUPDATER=1 \
    UV_LINK_MODE=copy
