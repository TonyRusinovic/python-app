#!/bin/bash
set -e

cleanup() {
  echo "Cleanup: removing runner..."
  if [ -x ./config.sh ]; then
    ./config.sh remove --unattended --token "$RUNNER_TOKEN" || true
  fi
  exit 0
}

trap 'cleanup' SIGTERM SIGINT

if [ -z "$GITHUB_URL" ] || [ -z "$RUNNER_TOKEN" ]; then
  echo "Environment variables GITHUB_URL and RUNNER_TOKEN are required."
  echo "Set GITHUB_URL=https://github.com/OWNER/REPO or https://github.com/ORG and RUNNER_TOKEN."
  exit 1
fi

RUNNER_NAME=${RUNNER_NAME:-$(hostname)}
RUNNER_LABELS=${RUNNER_LABELS:-self-hosted,docker}

# Ensure mounted workdir has the correct permissions for the runner user.
mkdir -p /home/runner/_work
chown -R runner:runner /home/runner/_work

./config.sh --url "$GITHUB_URL" --token "$RUNNER_TOKEN" --name "$RUNNER_NAME" \
  --labels "$RUNNER_LABELS" --unattended --replace

./run.sh &
wait $!
