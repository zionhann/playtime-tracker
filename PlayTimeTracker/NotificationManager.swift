//
//  NotificationManager.swift
//  PlayTimeTracker
//
//  Created by 한시온 on 11/10/25.
//

import Foundation
import UserNotifications

@MainActor
class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    @Published var isAuthorized: Bool = false

    private init() {
        Task {
            await checkAuthorization()
        }
    }

    func requestAuthorization() async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
            isAuthorized = granted
        } catch {
            print("Error requesting notification authorization: \(error)")
            isAuthorized = false
        }
    }

    func checkAuthorization() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isAuthorized = settings.authorizationStatus == .authorized
    }

    func sendPlaytimeNotification(message: String) {
        guard isAuthorized else { return }

        let content = UNMutableNotificationContent()
        content.title = "Playtime Update"
        content.body = message
        content.sound = .default

        // Create a trigger that fires immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
