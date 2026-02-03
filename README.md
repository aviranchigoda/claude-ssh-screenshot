# Claude SSH Screenshot

**One-keystroke screenshot sharing from Mac to remote Claude Code over SSH.**

Press `Cmd+Shift+V`, select an area, and the image path auto-pastes into your terminal. Claude can then read and analyze the image.

## The Problem

When you're SSH'd into a remote server running [Claude Code](https://claude.ai/code), you can't paste images directly - SSH doesn't share your clipboard. This tool solves that.

## The Solution

```
┌─────────────────────────────────────────────────────────────────┐
│                        Your Mac                                  │
│                                                                  │
│  Cmd+Shift+V → Screenshot selector → Upload via SCP             │
│                                                                  │
└──────────────────────────┬──────────────────────────────────────┘
                           │
                           │ SCP (SSH)
                           ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Remote Linux Server                          │
│                                                                  │
│  ~/.claude/paste-cache/images/2024-01-15_143022_a7f3b2.png      │
│                                                                  │
│  Path auto-pastes into your Claude Code terminal                │
│  Claude reads the image and responds                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

### Prerequisites

**On your Mac:**
- [Homebrew](https://brew.sh/)
- [Hammerspoon](https://www.hammerspoon.org/) (for keyboard shortcut)
- SSH access to your remote server

**On your server:**
- Claude Code installed and running

### Installation (5 minutes)

#### Step 1: Install dependencies on Mac

```bash
# Install pngpaste (extracts images from clipboard)
brew install pngpaste

# Install Hammerspoon (keyboard automation)
brew install --cask hammerspoon
```

#### Step 2: Download the script

```bash
# Create bin directory
mkdir -p ~/bin

# Download the script
curl -o ~/bin/claude-paste.sh https://raw.githubusercontent.com/aviranchigoda/claude-ssh-screenshot/main/mac/claude-paste.sh

# Make executable
chmod +x ~/bin/claude-paste.sh
```

#### Step 3: Configure the script

Edit `~/bin/claude-paste.sh` and update these variables:

```bash
# Your SSH alias or user@host
SSH_ALIAS="your-server-alias"

# Remote user's home directory
REMOTE_HOME_FALLBACK="/home/your-username"
```

#### Step 4: Set up server-side directory

```bash
# SSH into your server and create the images directory
ssh your-server 'mkdir -p ~/.claude/paste-cache/images'
```

#### Step 5: Configure Hammerspoon hotkey

Add to `~/.hammerspoon/init.lua`:

```lua
-- Claude Code Image Paste (Cmd+Shift+V)
hs.hotkey.bind({"cmd", "shift"}, "V", function()
    hs.execute(os.getenv("HOME") .. "/bin/claude-paste.sh", true)
end)
```

Then reload Hammerspoon: Click menu bar icon → Reload Config

#### Step 6: Grant permissions

1. Open Hammerspoon (it appears in your menu bar)
2. Go to **System Settings → Privacy & Security → Accessibility**
3. Enable **Hammerspoon**

## Usage

1. **Have Claude Code active** in your terminal (SSH'd into your server)
2. **Press `Cmd+Shift+V`**
3. **Select an area** with the crosshair cursor
4. **Path auto-pastes** into your terminal
5. **Type your question** and press Enter

### Example

```
You: /home/user/.claude/paste-cache/images/2024-01-15_143022_a7f3b2.png

What does this error message mean?

Claude: I can see the error in your screenshot. The issue is...
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `CLAUDE_SSH_ALIAS` | SSH alias or user@host | `linode-sydney` |

### Changing the Hotkey

Edit `~/.hammerspoon/init.lua`:

```lua
-- Example: Change to Ctrl+Shift+S
hs.hotkey.bind({"ctrl", "shift"}, "S", function()
    hs.execute(os.getenv("HOME") .. "/bin/claude-paste.sh", true)
end)
```

## Claude Code Triggers (Optional)

Add these triggers to your Claude Code configuration for convenience:

| Command | Action |
|---------|--------|
| `show images` | List recent uploaded images |
| `latest image` | Get path of most recent image |
| `clear images` | Delete old images (keeps last 10) |

See `server/triggers.json` for the configuration.

## Troubleshooting

See [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) for detailed solutions to common issues.

### Quick Fixes

**Crosshair doesn't appear:**
- Check Hammerspoon is running (menu bar icon)
- Reload config: Click icon → Reload Config
- Check Accessibility permissions

**Upload fails:**
- Test SSH: `ssh your-server 'echo OK'`
- Check directory exists: `ssh your-server 'ls ~/.claude/paste-cache/images/'`

**Path is garbled:**
- Make sure you're using `hs.execute()` not `hs.task.new()`
- Update your Hammerspoon config from this repo

## How It Works

1. **Hammerspoon** intercepts `Cmd+Shift+V` and runs the script
2. **screencapture -ic** opens macOS screenshot selector
3. **pngpaste** extracts the screenshot from clipboard
4. **scp** uploads the image to the remote server
5. **pbcopy** + **osascript keystroke "v"** pastes the path into your terminal
6. **Claude Code** reads the image using its Read tool

## File Structure

```
clause-ssh-screenshot/
├── README.md                 # This file
├── LICENSE                   # MIT License
├── mac/
│   ├── claude-paste.sh       # Main screenshot script
│   └── hammerspoon-init.lua  # Hammerspoon configuration
├── server/
│   ├── setup.sh              # Server setup script
│   └── triggers.json         # Claude Code triggers
└── docs/
    └── TROUBLESHOOTING.md    # Detailed troubleshooting
```

## Requirements

- **macOS** 12.0+ (Monterey or later)
- **Hammerspoon** 0.9.93+
- **pngpaste** (installed via Homebrew)
- **SSH access** to remote server
- **Claude Code** running on remote server

## License

MIT License - see [LICENSE](LICENSE)

## Contributing

Contributions welcome! Please open an issue or PR.

## Credits

Built with [Claude Code](https://claude.ai/code) by Anthropic.
