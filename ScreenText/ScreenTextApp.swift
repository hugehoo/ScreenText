import SwiftUI
import AppKit

@main
struct ScreenTextApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("ScreenText", systemImage: "text.viewfinder") {
            Button("Capture Text (⌘⇧2)") {
                appDelegate.startCapture()
            }
            .keyboardShortcut("2", modifiers: [.command, .shift])

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }
}
