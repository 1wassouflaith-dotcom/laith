#!/usr/bin/env bash
# Clones tradesdontlie/tradingview-mcp into $HOME, installs its deps, and
# registers it with Claude Code (user scope, i.e. available in every project).
#
# Run this on the machine where you actually use Claude Code — the server it
# registers talks to a locally running TradingView Desktop app, so it's no
# use in a cloud/CI session.
set -euo pipefail

REPO_URL="https://github.com/tradesdontlie/tradingview-mcp.git"
INSTALL_DIR="${HOME}/tradingview-mcp"

if ! command -v node >/dev/null 2>&1; then
  echo "Error: node is not installed or not on PATH. Node.js 18+ is required." >&2
  exit 1
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "Error: claude CLI is not installed or not on PATH." >&2
  exit 1
fi

if [ -d "${INSTALL_DIR}" ]; then
  echo "Found existing ${INSTALL_DIR}, skipping clone."
else
  git clone "${REPO_URL}" "${INSTALL_DIR}"
fi

(
  cd "${INSTALL_DIR}"
  npm install
)

claude mcp add tradingview -s user -- node "${INSTALL_DIR}/src/server.js"

cat <<EOF

Registered "tradingview" MCP server with Claude Code (user scope).

Next steps:
  1. Launch TradingView Desktop with remote debugging enabled, e.g.:
       ${INSTALL_DIR}/scripts/launch_tv_debug_linux.sh
     (see ${INSTALL_DIR}/README.md for the Mac/Windows equivalents), or run
     TradingView manually with --remote-debugging-port=9222.
  2. Restart Claude Code so it picks up the new MCP server.
  3. Ask Claude to run the tv_health_check tool to verify the connection.
EOF
