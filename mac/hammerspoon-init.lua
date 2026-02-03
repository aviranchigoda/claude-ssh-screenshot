-- =============================================================================
-- Claude Code Image Paste - Hammerspoon Configuration
-- =============================================================================
-- 
-- Add this to your ~/.hammerspoon/init.lua
-- Then reload Hammerspoon: Click menu bar icon → Reload Config
--
-- Prerequisites:
--   1. Install Hammerspoon: brew install --cask hammerspoon
--   2. Install pngpaste: brew install pngpaste
--   3. Copy claude-paste.sh to ~/bin/claude-paste.sh
--   4. Grant Accessibility permissions to Hammerspoon
--
-- =============================================================================

-- Claude Code Image Paste (Cmd+Shift+V)
-- 
-- Workflow:
--   1. Press Cmd+Shift+V
--   2. Select area with crosshair
--   3. Screenshot uploads to server
--   4. Path auto-pastes into your active terminal
--   5. Type your question and press Enter
--
hs.hotkey.bind({"cmd", "shift"}, "V", function()
    hs.execute(os.getenv("HOME") .. "/bin/claude-paste.sh", true)
end)

-- Optional: Uncomment to show confirmation when config loads
-- hs.alert.show("Claude Paste loaded: Cmd+Shift+V")
