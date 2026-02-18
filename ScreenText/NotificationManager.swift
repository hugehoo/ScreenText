import UserNotifications
import AppKit

struct NotificationManager {
    static func showSuccess(characterCount: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Text Captured"
        content.body = "\(characterCount) characters copied to clipboard"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error)")
            }
        }

        // Also request notification permissions if needed
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    static func showNoTextFound() {
        let content = UNMutableNotificationContent()
        content.title = "No Text Found"
        content.body = "Could not detect any text in the selected area"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { _ in }
    }

    static func showError() {
        let content = UNMutableNotificationContent()
        content.title = "Capture Failed"
        content.body = "An error occurred while processing the image"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request) { _ in }
    }
}
