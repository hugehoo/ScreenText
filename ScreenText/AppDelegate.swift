import AppKit
import Carbon.HIToolbox

class AppDelegate: NSObject, NSApplicationDelegate {
    private var eventMonitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        registerGlobalHotKey()
    }

    func applicationWillTerminate(_ notification: Notification) {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
        }
    }

    private func registerGlobalHotKey() {
        // Monitor for Cmd+Shift+2
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.modifierFlags.contains([.command, .shift]) && event.keyCode == 19 {
                DispatchQueue.main.async {
                    self?.startCapture()
                }
            }
        }
    }

    func startCapture() {
        NSLog("ScreenText: Starting capture")

        ScreenCaptureManager.captureInteractively { [weak self] image in
            self?.processCapture(image)
        }
    }

    private func processCapture(_ image: CGImage?) {
        guard let image = image else {
            NSLog("ScreenText: No image captured")
            return
        }

        NSLog("ScreenText: Processing image \(image.width)x\(image.height)")

        Task {
            do {
                let text = try await OCRProcessor.recognizeText(in: image)
                NSLog("ScreenText: OCR found \(text.count) characters")

                await MainActor.run {
                    if !text.isEmpty {
                        ClipboardManager.copy(text)
                        NotificationManager.showSuccess(characterCount: text.count)
                    } else {
                        NotificationManager.showNoTextFound()
                    }
                }
            } catch {
                NSLog("ScreenText: OCR error - \(error)")
                await MainActor.run {
                    NotificationManager.showError()
                }
            }
        }
    }
}
