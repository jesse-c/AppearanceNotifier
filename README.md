<div align='center'>
  <h1>Appearance Notifier</h1><br>
</div>

This application listens for when the macOS interface theme changes and then _does some thing(s)_. For now, it's hardcoded to switching my kitty and Neovim themes to match the new theme.

Ideally the different things themselves would handle this themselves, as others do.

## Installation

Clone this repository.

## Usage

In your terminal, navigate to the cloned repository and run:

```sh
swift run
```

You'll need to leave this running.

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

## Wishlist

- [ ] Autostart: For example, [use launchctl](https://arslan.io/2021/02/15/automatic-dark-mode-for-terminal-applications/)
- [ ] Use macOS OSLog
- [ ] Add tests
- [ ] Add native notifications
- [ ] Change configuration files so new instances have the right themes
- [ ] Move commands out of application
