# laith

## TradingView MCP setup

This repo includes a setup script for registering the [TradingView MCP
server](https://github.com/tradesdontlie/tradingview-mcp) with Claude Code on
your own machine.

This has to run on the machine where you actually use Claude Code — it
launches a local Node process that talks to a locally running TradingView
Desktop app over `--remote-debugging-port=9222`, so it can't be set up from a
cloud/CI session.

### Prerequisites

- Node.js 18+
- Claude Code CLI installed and on your `PATH`
- TradingView Desktop app installed

### Install

```bash
./scripts/setup-tradingview-mcp.sh
```

This will:

1. Clone `tradesdontlie/tradingview-mcp` into `~/tradingview-mcp` (skips the
   clone if that directory already exists — run `git -C ~/tradingview-mcp
   pull` yourself first if you want to update it).
2. Run `npm install` in that directory.
3. Register it with Claude Code via `claude mcp add tradingview -s user --
   node ~/tradingview-mcp/src/server.js`, which makes the server available
   globally (every project), not just in one repo.

### After running the script

1. **Launch TradingView Desktop with remote debugging enabled**, e.g. on
   Linux: `./scripts/launch_tv_debug_linux.sh` inside `~/tradingview-mcp`
   (see that repo's README for the Mac/Windows equivalents), or manually:
   `/path/to/TradingView --remote-debugging-port=9222`.
2. **Restart Claude Code** so it picks up the newly registered MCP server.
3. Ask Claude to run the `tv_health_check` tool to confirm the connection to
   TradingView Desktop is working.
