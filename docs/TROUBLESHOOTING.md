# Troubleshooting Guide

Common issues and solutions for Claude SSH Screenshot.

## Table of Contents

- [Crosshair Doesn't Appear](#crosshair-doesnt-appear)
- [Upload Fails](#upload-fails)
- [Path is Garbled](#path-is-garbled)
- [No Sound on Success](#no-sound-on-success)
- [Permission Denied](#permission-denied)
- [Hammerspoon Issues](#hammerspoon-issues)

---

## Crosshair Doesn't Appear

### Symptoms
- Press Cmd+Shift+V but nothing happens
- No crosshair cursor appears

### Solutions

**1. Check Hammerspoon is running**
```bash
# Look for Hammerspoon in menu bar (hammer icon)
# Or check if process is running:
ps aux | grep -i hammerspoon
```

**2. Reload Hammerspoon config**
- Click Hammerspoon menu bar icon → Reload Config
- Or run in Hammerspoon console: `hs.reload()`

**3. Check Accessibility permissions**
- System Settings → Privacy & Security → Accessibility
- Ensure Hammerspoon is enabled
- Try toggling it off and on

**4. Verify the script exists**
```bash
ls -la ~/bin/claude-paste.sh
```

**5. Test script directly**
```bash
~/bin/claude-paste.sh
```

---

## Upload Fails

### Symptoms
- Crosshair appears, you select area
- Notification says "Upload failed"

### Solutions

**1. Test SSH connection**
```bash
ssh your-server-alias 'echo "Connection OK"'
```

**2. Check remote directory exists**
```bash
ssh your-server-alias 'ls -la ~/.claude/paste-cache/images/'
```

**3. Create directory if missing**
```bash
ssh your-server-alias 'mkdir -p ~/.claude/paste-cache/images'
```

**4. Check SSH alias in script**
```bash
# Edit the script and verify SSH_ALIAS is correct:
grep SSH_ALIAS ~/bin/claude-paste.sh
```

**5. Test SCP manually**
```bash
echo "test" > /tmp/test.txt
scp /tmp/test.txt your-server-alias:~/.claude/paste-cache/images/
```

---

## Path is Garbled

### Symptoms
- Upload succeeds but path appears as:
  ```
  [57410uai_d[57410u[57409uclaude...
  ```

### Solutions

**1. Update Hammerspoon config**

Use `hs.execute()` instead of `hs.task.new()`:

```lua
-- WRONG (causes garbled text):
hs.hotkey.bind({"cmd", "shift"}, "V", function()
    local task = hs.task.new(...)
    task:start()
end)

-- CORRECT:
hs.hotkey.bind({"cmd", "shift"}, "V", function()
    hs.execute(os.getenv("HOME") .. "/bin/claude-paste.sh", true)
end)
```

**2. Reload Hammerspoon after changing**
- Click menu bar icon → Reload Config

---

## No Sound on Success

### Symptoms
- Everything works but no Glass sound plays

### Solutions

**1. Check system volume**
- Make sure Mac isn't muted

**2. Check sound file exists**
```bash
ls /System/Library/Sounds/Glass.aiff
```

**3. Test sound manually**
```bash
afplay /System/Library/Sounds/Glass.aiff
```

---

## Permission Denied

### Symptoms
- Script fails with "permission denied"

### Solutions

**1. Make script executable**
```bash
chmod +x ~/bin/claude-paste.sh
```

**2. Check file permissions**
```bash
ls -la ~/bin/claude-paste.sh
# Should show: -rwxr-xr-x
```

---

## Hammerspoon Issues

### Console shows errors

Open Hammerspoon console to see errors:
- Click menu bar icon → Console

### Common console errors

**"attempt to call a nil value"**
- The function doesn't exist. Check spelling.

**"cannot open /Users/.../claude-paste.sh"**
- Script doesn't exist at that path
- Run: `ls ~/bin/claude-paste.sh`

### Hotkey doesn't register

Check if another app is using Cmd+Shift+V:
```lua
-- In Hammerspoon console, check all hotkeys:
hs.inspect(hs.hotkey.getHotkeys())
```

---

## Still Having Issues?

1. **Enable debug mode** - Add `set -x` at the top of claude-paste.sh
2. **Check Hammerspoon console** for errors
3. **Test each step manually**:
   - `screencapture -ic` (take screenshot)
   - `pngpaste /tmp/test.png` (extract from clipboard)
   - `scp /tmp/test.png server:path/` (upload)

4. **Open an issue** on GitHub with:
   - Your macOS version
   - Hammerspoon console output
   - Script output with `set -x` enabled
