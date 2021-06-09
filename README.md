<div align='center'>
  <h1>Appearance Notifier</h1><br>
</div>

This application listens for when the macOS interface theme changes and then _does some thing(s)_. For now, it's hardcoded to switching my kitty and Neovim themes to match the new theme.

Ideally the different things themselves would handle this themselves, as others do.

## Installation

### Binaries

1. Download the latest version from the Releases page.
2. Move it to your path.

### From source

1. `$ git clone git@github.com:jesse-c/AppearanceNotifier.git`
2. `$ swift build --configuration release`.
3. `$ .build/x86_64-apple-macosx/release/AppearanceNotifier /usr/local/bin/`

## Usage

You'll need to adapt the `respond` function for your local machine's setup.

Run the compiled binary (e.g. `$ AppearanceNotifier`). You'll need to leave this running.

## Dependencies

**Neovim**

[nvim-remote](https://github.com/mhinz/neovim-remote) is used for controlling the Neovim instances.

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
