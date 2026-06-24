FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/home/runner/.local/bin:${PATH}"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    sudo \
    tar \
    gzip \
    python3 \
    python3-pip \
  && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m runner
WORKDIR /home/runner

# Download latest GitHub Actions runner release and extract
RUN LATEST_URL=$(curl -s https://api.github.com/repos/actions/runner/releases/latest \
    | jq -r '.assets[] | select(.name | test("actions-runner-linux-x64")) | .browser_download_url') \
  && curl -fsSL -o actions-runner.tar.gz "$LATEST_URL" \
  && tar xzf actions-runner.tar.gz \
  && rm actions-runner.tar.gz \
  && ./bin/installdependencies.sh \
  && chown -R runner:runner /home/runner

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
  && mkdir -p /home/runner/_work \
  && chown -R runner:runner /home/runner

USER runner
ENTRYPOINT ["/entrypoint.sh"]
