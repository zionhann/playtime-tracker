//
//  SystemEventMonitor.swift
//  PlayTimeTracker
//
//  Created by 한시온 on 11/10/25.
//

import Foundation
import AppKit

class SystemEventMonitor {
    private var sleepObserver: NSObjectProtocol?
    private var wakeObserver: NSObjectProtocol?

    var onSleep: (() -> Void)?
    var onWake: (() -> Void)?

    init() {
        setupObservers()
    }

    private func setupObservers() {
        let workspace = NSWorkspace.shared

        // Observe sleep notification
        sleepObserver = workspace.notificationCenter.addObserver(
            forName: NSWorkspace.willSleepNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.onSleep?()
        }

        // Observe wake notification
        wakeObserver = workspace.notificationCenter.addObserver(
            forName: NSWorkspace.didWakeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.onWake?()
        }

        // Observe screen sleep
        workspace.notificationCenter.addObserver(
            forName: NSWorkspace.screensDidSleepNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.onSleep?()
        }

        // Observe screen wake
        workspace.notificationCenter.addObserver(
            forName: NSWorkspace.screensDidWakeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.onWake?()
        }
    }

    deinit {
        if let sleepObserver = sleepObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(sleepObserver)
        }
        if let wakeObserver = wakeObserver {
            NSWorkspace.shared.notificationCenter.removeObserver(wakeObserver)
        }
    }
}
