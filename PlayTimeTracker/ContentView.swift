//
//  ContentView.swift
//  PlayTimeTracker
//
//  Created by 한시온 on 11/10/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appCoordinator: AppCoordinator
    @StateObject private var userSettings = UserSettings()
    @StateObject private var notificationManager = NotificationManager.shared

    @State private var lastNotificationMinutes: Int = 0

    var body: some View {
        VStack(spacing: 30) {
            // Header
            Text("Laptop Playtime Tracker")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Main playtime display
            VStack(spacing: 15) {
                Image(systemName: "desktopcomputer")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)

                Text(appCoordinator.playTimeManager.formattedTime)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                Text("Total Playtime Today")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(nsColor: .controlBackgroundColor))
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            )

            Divider()
                .padding(.horizontal)

            // Settings Section
            VStack(alignment: .leading, spacing: 15) {
                Text("Settings")
                    .font(.headline)
                    .foregroundColor(.secondary)

                // Notifications Toggle
                Toggle("Enable Notifications", isOn: $userSettings.notificationsEnabled)
                    .toggleStyle(.switch)

                // Notification Interval Picker
                if userSettings.notificationsEnabled {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notification Interval")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Picker("Interval", selection: $userSettings.notificationInterval) {
                            ForEach(userSettings.availableIntervals, id: \.self) { interval in
                                Text(userSettings.intervalLabel(for: interval))
                                    .tag(interval)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .transition(.opacity)
                }

                // Status indicator
                HStack {
                    Circle()
                        .fill(appCoordinator.playTimeManager.isTracking ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    Text(appCoordinator.playTimeManager.isTracking ? "Tracking Active" : "Tracking Paused")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            .animation(.easeInOut, value: userSettings.notificationsEnabled)

            Spacer()

            // Reset Button
            Button(action: {
                appCoordinator.playTimeManager.resetTracking()
                lastNotificationMinutes = 0
            }) {
                Label("Reset Playtime", systemImage: "arrow.counterclockwise")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.red, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
            }
            .buttonStyle(.plain)
            .padding(.horizontal)

            // Info text
            Text("Playtime resets automatically when your laptop sleeps or shuts down")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .frame(minWidth: 500, minHeight: 600)
        .onChange(of: appCoordinator.playTimeManager.elapsedSeconds) { _, newValue in
            checkForNotification(seconds: newValue)
        }
        .task {
            if !notificationManager.isAuthorized {
                await notificationManager.requestAuthorization()
            }
        }
    }

    private func checkForNotification(seconds: Int) {
        guard userSettings.notificationsEnabled else { return }

        let currentMinutes = seconds / 60
        let intervalMinutes = userSettings.notificationInterval

        // Check if we've crossed an interval threshold
        if currentMinutes > 0 && currentMinutes % intervalMinutes == 0 && currentMinutes != lastNotificationMinutes {
            lastNotificationMinutes = currentMinutes
            notificationManager.sendPlaytimeNotification(message: appCoordinator.playTimeManager.notificationMessage)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AppCoordinator())
}
