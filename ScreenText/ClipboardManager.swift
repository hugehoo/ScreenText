import AppKit

struct ClipboardManager {
    static func copy(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        let success = pasteboard.setString(text, forType: .string)
        NSLog("ScreenText: Copied to clipboard (success=\(success)): \(text.prefix(50))...")
    }
}
