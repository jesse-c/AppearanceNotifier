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
            switch style {
            case .Light:
                let output = try shellOut(to: "kitty", arguments: [
                    "@", "--to", "unix:/tmp/kitty", "set-colors", "--all", "--configured", "/Users/jesse/.config/kitty/colours/sainnhe/edge/edge-light.conf",

                ])
            case .Dark:
                let output = try shellOut(to: "kitty", arguments: [
                    "@", "--to", "unix:/tmp/kitty", "set-colors", "--all", "--configured", "/Users/jesse/.config/kitty/colours/sainnhe/edge/edge-dark.conf",

                ])
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
