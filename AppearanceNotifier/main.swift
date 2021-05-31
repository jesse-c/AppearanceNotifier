//
//  main.swift
//  AppearanceNotifier
//
//  Created by Jesse Claven on 31/5/21.
//

import Foundation
import AppKit

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
            using: self.interfaceModeChanged(notification:)
        )
    }

    func interfaceModeChanged(notification: Notification) {        
      let styleRaw = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") ?? "Light"
      let style = Theme(rawValue: styleRaw)!
      
      print("Theme changed: \(style)")
    }
}

let app = NSApplication.shared

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        let observer = DarkModeObserver.init()
        observer.observe()
    }

}

let delegate = AppDelegate()
app.delegate = delegate
app.run()
