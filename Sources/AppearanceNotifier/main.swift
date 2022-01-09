import AppKit
import Foundation
import ShellOut

private let kAppleInterfaceThemeChangedNotification = "AppleInterfaceThemeChangedNotification"

enum Theme: String {
    case Light, Dark
}

class ThemeChangeObserver {
    func observe() {
        print("Observing")

        DistributedNotificationCenter.default.addObserver(
            forName: Notification.Name(kAppleInterfaceThemeChangedNotification),
            object: nil,
            queue: nil,
            using: interfaceModeChanged(notification:)
        )
    }

    func interfaceModeChanged(notification _: Notification) {
        let themeRaw = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
        let theme = Theme(rawValue: themeRaw)!

        notify(theme: theme)

        respond(theme: theme)
    }
}

func notify(theme: Theme) {
    print("\(Date()) Theme changed: \(theme)")
}

func respond(theme: Theme) {
    do {
        let output = try shellOut(to: "nvr", arguments: ["--serverlist"])
        let servers = output.split(whereSeparator: \.isNewline)

        if servers.isEmpty {
            print("\(Date()) neovim: no servers")
        } else {
            servers.forEach { server in
                let server = String(server)

                print("\(Date()) neovim server (\(String(server))): sending command")

                let arguments = build_nvim_background_arguments(server: server, theme: theme)

                DispatchQueue.global().async {
                    do {
                        try shellOut(to: "nvr", arguments: arguments)
                    } catch {
                        print("\(Date()) neovim server \(String(server)): command failed")
                    }
                }
            }
        }

        DispatchQueue.global().async {
            print("\(Date()) neovim: updating config")

            let arguments = [
                "-E",
                "-i",
                "\"\"",
                "\"1s/.*/return '\(theme.rawValue.lowercased())_default'/g\"",
                "~/.config/nvim/lua/user/ui/theme.lua",
            ]

            do {
                try shellOut(to: "sed", arguments: arguments)
            } catch {
                print("\(Date()) neovim: config update failed")
            }
        }

        DispatchQueue.global().async {
            print("\(Date()) kitty: updating config")

            let arguments = [
                "-E",
                "-i",
                "\"\"",
                "\"2s/.*/include ..\\/colours\\/projekt0n\\/github-nvim-theme\\/github_\(theme.rawValue.lowercased())_default.conf/g\"",
                "~/.config/kitty/conf/colours.conf",
            ]

            do {
                try shellOut(to: "sed", arguments: arguments)
            } catch {
                print("\(Date()) kitty: config update failed")
            }
        }

        DispatchQueue.global().async {
            print("\(Date()) kitty: sending command")

            let arguments = build_kitty_arguments(theme: "~/.config/kitty/colours/projekt0n/github-nvim-theme/github_\(theme.rawValue.lowercased())_default.conf")

            do {
                try shellOut(to: "kitty", arguments: arguments)
            } catch {
                print("\(Date()) kitty: command failed")
            }
        }
    } catch {
        let error = error as! ShellOutError
        print(error.message) // Prints STDERR
        print(error.output) // Prints STDOUT
    }
}

func build_nvim_background_arguments(server: String, theme: Theme) -> [String] {
    return ["--servername", server, "+'colorscheme github_\(theme.rawValue.lowercased())_default'"]
}

func build_kitty_arguments(theme: String) -> [String] {
    return [
        "@", "--to", "unix:/tmp/kitty", "set-colors", "--all", "--configured", theme,
    ]
}

let app = NSApplication.shared

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        let observer = ThemeChangeObserver()
        observer.observe()
    }
}

let delegate = AppDelegate()
app.delegate = delegate
app.run()
