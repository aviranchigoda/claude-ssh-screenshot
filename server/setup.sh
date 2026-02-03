#!/bin/bash
# =============================================================================
# setup.sh - Server-side setup for Claude SSH Screenshot
# =============================================================================
# Run this script on your remote server to set up the image cache directory.
# =============================================================================

set -euo pipefail

echo "Setting up Claude SSH Screenshot on server..."
echo ""

# Create images directory
IMAGES_DIR="$HOME/.claude/paste-cache/images"
if [ ! -d "$IMAGES_DIR" ]; then
    mkdir -p "$IMAGES_DIR"
    echo "✓ Created directory: $IMAGES_DIR"
else
    echo "✓ Directory already exists: $IMAGES_DIR"
fi

# Set permissions
chmod 700 "$HOME/.claude/paste-cache"
chmod 700 "$IMAGES_DIR"
echo "✓ Set directory permissions"

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "  1. On your Mac, install the claude-paste.sh script"
echo "  2. Configure Hammerspoon with the hotkey"
echo "  3. Press Cmd+Shift+V to test"
echo ""
echo "Images will be stored in: $IMAGES_DIR"
