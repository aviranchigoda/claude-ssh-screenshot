# SSH Screenshot Tool

**One-keystroke screenshot sharing from Mac to a remote Linux server over SSH.**

Press `Cmd+Shift+V`, select an area, and the image path auto-pastes into the terminal. An AI assistant can then read and analyze the image.

## The Problem

When SSH'd into a remote server running an AI coding assistant, images cannot be pasted directly - SSH doesn't share the clipboard. This tool solves that.

## The Solution

```
┌─────────────────────────────────────────────────────────────────┐
│                          Mac                                     │
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
│  Path auto-pastes into the active terminal                      │
│  The AI assistant reads the image and responds                  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

### Prerequisites

**On the Mac:**
- [Homebrew](https://brew.sh/)
- [Hammerspoon](https://www.hammerspoon.org/) (for keyboard shortcut)
- SSH access to the remote server

**On the server:**
- An AI coding assistant installed and running

### Installation (5 minutes)

#### Step 1: Install dependencies on the Mac

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
# The SSH alias or user@host
SSH_ALIAS="server-alias"

# Remote user's home directory
REMOTE_HOME_FALLBACK="/home/username"
```

#### Step 4: Set up server-side directory

```bash
# SSH into the server and create the images directory
ssh server-alias 'mkdir -p ~/.claude/paste-cache/images'
```

#### Step 5: Configure Hammerspoon hotkey

Add to `~/.hammerspoon/init.lua`:

```lua
-- SSH Image Paste (Cmd+Shift+V)
hs.hotkey.bind({"cmd", "shift"}, "V", function()
    hs.execute(os.getenv("HOME") .. "/bin/claude-paste.sh", true)
end)
```

Then reload Hammerspoon: Click menu bar icon → Reload Config

#### Step 6: Grant permissions

1. Open Hammerspoon (it appears in the menu bar)
2. Go to **System Settings → Privacy & Security → Accessibility**
3. Enable **Hammerspoon**

## Usage

1. **Have the AI assistant active** in the terminal (SSH'd into the server)
2. **Press `Cmd+Shift+V`**
3. **Select an area** with the crosshair cursor
4. **Path auto-pastes** into the terminal
5. **Type a question** and press Enter

### Example

```
User: /home/user/.claude/paste-cache/images/2024-01-15_143022_a7f3b2.png

What does this error message mean?

Assistant: The error in the screenshot indicates...
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|--------|
| `CLAUDE_SSH_ALIAS` | SSH alias or user@host | `linode-sydney` |

### Changing the Hotkey

Edit `~/.hammerspoon/init.lua`:

```lua
-- Example: Change to Ctrl+Shift+S
hs.hotkey.bind({"ctrl", "shift"}, "S", function()
    hs.execute(os.getenv("HOME") .. "/bin/claude-paste.sh", true)
end)
```

## Optional Triggers

Add these triggers to the AI assistant configuration for convenience:

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
- Test SSH: `ssh server-alias 'echo OK'`
- Check directory exists: `ssh server-alias 'ls ~/.claude/paste-cache/images/'`

**Path is garbled:**
- Make sure `hs.execute()` is used, not `hs.task.new()`
- Update the Hammerspoon config from this repo

## How It Works

1. **Hammerspoon** intercepts `Cmd+Shift+V` and runs the script
2. **screencapture -ic** opens the macOS screenshot selector
3. **pngpaste** extracts the screenshot from clipboard
4. **scp** uploads the image to the remote server
5. **pbcopy** + **osascript keystroke "v"** pastes the path into the terminal
6. **The AI assistant** reads the image using its file read capability

## File Structure

```
ssh-screenshot/
├── README.md                 # This file
├── LICENSE                   # MIT License
├── mac/
│   ├── claude-paste.sh       # Main screenshot script
│   └── hammerspoon-init.lua  # Hammerspoon configuration
├── server/
│   ├── setup.sh              # Server setup script
│   └── triggers.json         # Optional triggers
└── docs/
    └── TROUBLESHOOTING.md    # Detailed troubleshooting
```

## Requirements

- **macOS** 12.0+ (Monterey or later)
- **Hammerspoon** 0.9.93+
- **pngpaste** (installed via Homebrew)
- **SSH access** to the remote server
- **An AI coding assistant** running on the remote server

## License

MIT License - see [LICENSE](LICENSE)

## Contributing

Contributions welcome! Please open an issue or PR.
