//
//  UserSettings.swift
//  PlayTimeTracker
//
//  Created by 한시온 on 11/10/25.
//

import Foundation
import SwiftUI

@MainActor
class UserSettings: ObservableObject {
    @AppStorage("notificationInterval") var notificationInterval: Int = 30 { // Default: 30 minutes
        willSet {
            objectWillChange.send()
        }
    }
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = true {
        willSet {
            objectWillChange.send()
        }
    }

    // Available notification intervals (in minutes)
    let availableIntervals: [Int] = [15, 30, 60, 90, 120]

    var notificationIntervalLabel: String {
        if notificationInterval == 60 {
            return "1 hour"
        } else if notificationInterval >= 60 {
            let hours = notificationInterval / 60
            let minutes = notificationInterval % 60
            if minutes == 0 {
                return "\(hours) hours"
            } else {
                return "\(hours)h \(minutes)m"
            }
        } else {
            return "\(notificationInterval) minutes"
        }
    }

    func intervalLabel(for minutes: Int) -> String {
        if minutes == 60 {
            return "1 hour"
        } else if minutes >= 60 {
            let hours = minutes / 60
            let mins = minutes % 60
            if mins == 0 {
                return "\(hours) hour\(hours > 1 ? "s" : "")"
            } else {
                return "\(hours)h \(mins)m"
            }
        } else {
            return "\(minutes) minutes"
        }
    }
}
