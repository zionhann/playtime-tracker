//
//  PlayTimeTrackerApp.swift
//  PlayTimeTracker
//
//  Created by 한시온 on 11/10/25.
//

import SwiftUI
import Combine

@main
struct PlayTimeTrackerApp: App {
    @StateObject private var appCoordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appCoordinator)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
    }
}

@MainActor
class AppCoordinator: ObservableObject {
    private var systemEventMonitor: SystemEventMonitor?
    @Published var playTimeManager = PlayTimeManager()
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSystemEventMonitoring()

        // Forward PlayTimeManager changes to AppCoordinator's objectWillChange
        playTimeManager.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        .store(in: &cancellables)
    }

    private func setupSystemEventMonitoring() {
        systemEventMonitor = SystemEventMonitor()

        // Reset playtime when system goes to sleep
        systemEventMonitor?.onSleep = { [weak self] in
            Task { @MainActor in
                self?.playTimeManager.resetTracking()
            }
        }

        // Resume tracking when system wakes up
        systemEventMonitor?.onWake = { [weak self] in
            Task { @MainActor in
                self?.playTimeManager.startTracking()
            }
        }
    }
}
