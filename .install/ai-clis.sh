#!/usr/bin/env bash
set -euo pipefail

if ! command -v npm >/dev/null 2>&1; then
    echo "npm not found; skipping AI CLIs."
    exit 0
fi

npm install -g \
    @anthropic-ai/claude-code \
    @openai/codex \
    @google/gemini-cli
