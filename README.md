<div align='center'>
  <h1>Appearance Notifier</h1><br>
</div>

This application listens for when the macOS interface theme changes and then _does some thing(s)_. For now, it's hardcoded to switching my kitty and Neovim themes to match the new theme.

Ideally the different things themselves would handle this themselves, as others do.

## Demo

![appearancenotifier-demo-with-kitty-neovim](https://user-images.githubusercontent.com/1405676/121757359-d2b42700-cb0c-11eb-8db1-47d91aa5196c.gif)

NB: This demo is from a 2012 13" MacBook Pro.

## Installation

### Binaries

1. Download the latest version from the Releases page.
2. Move it to your path.

### From source

1. `$ git clone git@github.com:jesse-c/AppearanceNotifier.git`
2. `$ swift build --configuration release`.
3. `$ mv .build/x86_64-apple-macosx/release/AppearanceNotifier /usr/local/bin/`

## Usage

You'll need to adapt the `respond` function for your local machine's setup.

Run the compiled binary (e.g. `$ AppearanceNotifier`). You'll need to leave this running.

### Autostart

To have it autostart at login, you can use `launchd`, with the provided job definition. Copy it to the right location (e.g. `$ cp com.jesseclaven.appearancenotifier.plist ~/Library/LaunchAgents/`).

## Dependencies

**Neovim**

[nvim-remote](https://github.com/mhinz/neovim-remote) (aka `nvr`) is used for controlling the Neovim instances.

**kitty**

For kitty to receive remote commands, you'll need to update your config to have:

```
allow_remote_control true
```

**kitty / tmux**

If you're using kitty with tmux, you'll need to explicitly set the socket that kitty listens on, since if you run the command from within tmux, kitty won't pick up on it.

How you do this depends on how you start kitty.

If you're starting it from the application icon, you need to set the launch arguments in your kitty config folder. For example, in `~/.config/kitty/macos-launch-services-cmdline` I have:

```
--listen-on unix:/tmp/kitty
```

NB: If you don't open kitty directly from the application (for example, if you're using Raycast), then it won't pick up these launch arguments.

NB: I haven't tested this with more than 1 kitty window.

**Emacs**

You'll need to have the server running.

**Helix**

No specific setup is needed.

## FAQ

Q. What if my laptop is asleep and it passes sunrise/sunset?

A. From what I've observed, my laptop has already switched, or does so immediately, after I directly wake it up.
