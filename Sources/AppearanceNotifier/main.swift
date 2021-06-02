import AppKit
import Foundation
import ShellOut

private let kAppleInterfaceThemeChangedNotification = "AppleInterfaceThemeChangedNotification"

enum Theme: String {
    case Light, Dark
}

class DarkModeObserver {
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
        let styleRaw = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
        let style = Theme(rawValue: styleRaw)!

        print("\(Date()) Theme changed: \(style)")

        do {
            let output = try shellOut(to: "nvr", arguments: ["--serverlist"])
            let servers = output.split(whereSeparator: \.isNewline)

            servers.forEach { server in
                print("\(Date()) server \(String(server)): sending command")

                DispatchQueue.global().async {
                    do {
                        try shellOut(
                            to: "nvr",
                            arguments: ["--servername", String(server), "+'set background=\(style.rawValue.lowercased())'"]
                        )
                    } catch {
                        print("\(Date()) server \(String(server)): command failed")
                    }
                }
            }

            switch style {
            case .Light:
                DispatchQueue.global().async {
                    print("\(Date()) kitty: sending command")

                    do {
                        try shellOut(to: "kitty", arguments: [
                            "@", "--to", "unix:/tmp/kitty", "set-colors", "--all", "--configured", "/Users/jesse/.config/kitty/colours/sainnhe/edge/edge-light.conf",

                        ])
                    } catch {
                        print("\(Date()) kitty: command failed")
                    }
                }
            case .Dark:
                DispatchQueue.global().async {
                    print("\(Date()) kitty: sending command")

                    do {
                        try shellOut(to: "kitty", arguments: [
                            "@", "--to", "unix:/tmp/kitty", "set-colors", "--all", "--configured", "/Users/jesse/.config/kitty/colours/sainnhe/edge/edge-dark.conf",

                        ])
                    } catch {
                        print("\(Date()) kitty: command failed")
                    }
                }
            }
        } catch {
            let error = error as! ShellOutError
            print(error.message) // Prints STDERR
            print(error.output) // Prints STDOUT
        }
    }
}

let app = NSApplication.shared

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        let observer = DarkModeObserver()
        observer.observe()
    }
}

let delegate = AppDelegate()
app.delegate = delegate
app.run()
