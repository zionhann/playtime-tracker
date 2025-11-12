//
//  PlayTimeManager.swift
//  PlayTimeTracker
//
//  Created by 한시온 on 11/10/25.
//

import Foundation
import Combine

@MainActor
class PlayTimeManager: ObservableObject {
    @Published var elapsedSeconds: Int = 0
    @Published var isTracking: Bool = false

    private nonisolated(unsafe) var timer: Timer?
    private var startTime: Date?

    // Computed property to format time as HH:MM:SS
    var formattedTime: String {
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60
        let seconds = elapsedSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    // Computed property for notification display
    var notificationMessage: String {
        let hours = elapsedSeconds / 3600
        let minutes = (elapsedSeconds % 3600) / 60

        if hours > 0 {
            return "You've been using your laptop for \(hours) hour\(hours > 1 ? "s" : "") and \(minutes) minute\(minutes != 1 ? "s" : "")"
        } else {
            return "You've been using your laptop for \(minutes) minute\(minutes != 1 ? "s" : "")"
        }
    }

    init() {
        startTracking()
    }

    func startTracking() {
        guard !isTracking else { return }

        isTracking = true
        startTime = Date()

        // Update every second on the main runloop
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.elapsedSeconds += 1
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    func stopTracking() {
        isTracking = false
        timer?.invalidate()
        timer = nil
    }

    func resetTracking() {
        stopTracking()
        elapsedSeconds = 0
        startTracking()
    }

    nonisolated deinit {
        // Can't call @MainActor methods in deinit, so manually invalidate timer
        timer?.invalidate()
    }
}
