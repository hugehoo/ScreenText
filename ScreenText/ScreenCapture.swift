import AppKit

class ScreenCaptureManager {
    static func captureInteractively(completion: @escaping (CGImage?) -> Void) {
        // Use macOS built-in screencapture tool
        let tempFile = NSTemporaryDirectory() + "screentext_capture.png"

        // Remove old file if exists
        try? FileManager.default.removeItem(atPath: tempFile)

        // Run screencapture -i (interactive selection) -x (no sound)
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/sbin/screencapture")
        task.arguments = ["-i", "-x", tempFile]

        task.terminationHandler = { process in
            DispatchQueue.main.async {
                // Check if file was created (user didn't cancel)
                if FileManager.default.fileExists(atPath: tempFile),
                   let image = NSImage(contentsOfFile: tempFile),
                   let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                    NSLog("ScreenText: Captured image \(cgImage.width)x\(cgImage.height)")
                    completion(cgImage)

                    // Cleanup
                    try? FileManager.default.removeItem(atPath: tempFile)
                } else {
                    NSLog("ScreenText: Capture cancelled or failed")
                    completion(nil)
                }
            }
        }

        do {
            try task.run()
        } catch {
            NSLog("ScreenText: Failed to run screencapture: \(error)")
            completion(nil)
        }
    }
}
