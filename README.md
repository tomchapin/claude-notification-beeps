# claude-notification-beeps

A Claude Code plugin that plays a notification beep when Claude finishes a task, but only if your terminal isn't focused.

> **Note:** This plugin currently only supports Windows with PowerShell and Windows Terminal. See the [TODO](#todo) section for planned cross-platform support.

## Features

- Plays a short beep (440Hz, 150ms) when Claude sends a notification
- Only beeps when Windows Terminal is not the foreground window
- Helps you know when Claude is done while you're working in another app

## Installation

### From Marketplace

```
/plugin marketplace add tomchapin/claude-notification-beeps
/plugin install claude-notification-beeps@tomchapin-claude-notification-beeps
```

### Local Installation (for testing)

```bash
claude --plugin-dir /path/to/claude-notification-beeps
```

## Requirements

- Windows 10/11
- PowerShell
- Windows Terminal

## Configuration

Configure the plugin by adding environment variables to your `~/.claude/settings.json`:

```json
{
  "env": {
    "BEEP_FREQUENCY": "440",
    "BEEP_DURATION": "150",
    "BEEP_NOTIFICATION_TYPES": "permission_prompt|idle_prompt"
  }
}
```

### Options

| Variable | Default | Description |
|----------|---------|-------------|
| `BEEP_FREQUENCY` | `440` | Beep frequency in Hz (try 440-1000) |
| `BEEP_DURATION` | `150` | Beep duration in milliseconds |
| `BEEP_NOTIFICATION_TYPES` | *(all)* | Pipe-separated list of notification types to beep on |

### Valid Notification Types

- `permission_prompt` - Claude needs permission to run a command, access a file, etc.
- `idle_prompt` - Claude has been waiting for user input for 60+ seconds
- `auth_success` - Authentication completed successfully
- `elicitation_dialog` - Claude needs input for an MCP tool

### Examples

**Louder, longer beep:**
```json
{
  "env": {
    "BEEP_FREQUENCY": "800",
    "BEEP_DURATION": "300"
  }
}
```

**Only beep on permission prompts and idle:**
```json
{
  "env": {
    "BEEP_NOTIFICATION_TYPES": "permission_prompt|idle_prompt"
  }
}
```

**Beep on all notification types (explicit):**
```json
{
  "env": {
    "BEEP_NOTIFICATION_TYPES": "permission_prompt|idle_prompt|auth_success|elicitation_dialog"
  }
}
```

## How It Works

The plugin hooks into Claude Code's `Notification` event. When triggered, it runs a PowerShell script that:

1. Gets the currently focused window using Win32 APIs
2. Checks if it's Windows Terminal
3. If not, plays a beep to alert you

## When Does It Beep?

The plugin triggers on all Claude Code notification events:

| Notification Type | Description |
|-------------------|-------------|
| `permission_prompt` | Claude needs permission to run a command, access a file, etc. |
| `idle_prompt` | Claude has been waiting for user input for 60+ seconds |
| `auth_success` | Authentication completed successfully |
| `elicitation_dialog` | Claude needs input for an MCP tool |

By default, this plugin triggers on **all** notification types. To filter to specific events, set the `BEEP_NOTIFICATION_TYPES` environment variable (see [Configuration](#configuration)).

## TODO

- [ ] **macOS support** - Use `osascript` or `afplay` with a sound file, detect terminal focus via AppleScript
- [ ] **Linux support** - Use `paplay`, `aplay`, or `beep` command, detect terminal focus via `xdotool` or similar
- [ ] **Cross-platform script selection** - Auto-detect OS and run the appropriate script
- [x] **Configurable sound** - Frequency and duration via environment variables
- [x] **Configurable notification types** - Filter which events trigger beeps
- [ ] **Configurable terminal detection** - Support other terminals beyond Windows Terminal (iTerm2, Alacritty, etc.)

Contributions welcome!

## License

MIT
