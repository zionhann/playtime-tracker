# 🕹️ Laptop Playtime Tracker

A modern macOS application built with SwiftUI that tracks your laptop usage time and sends periodic notifications to keep you informed about your screen time.

## ✨ Features

- **Real-time Playtime Tracking**: Monitors laptop usage with second-by-second precision
- **Customizable Notifications**: Get playtime updates at intervals you choose (15, 30, 60, 90, or 120 minutes)
- **Smart Sleep Detection**: Automatically resets playtime when your laptop goes to sleep or shuts down
- **Beautiful SwiftUI Interface**: Modern, native macOS design with gradient effects and smooth animations
- **User Preferences**: Toggle notifications on/off and customize notification intervals
- **Status Indicator**: Visual feedback showing when tracking is active

## 🎯 How It Works

1. **Launch the app** - Tracking starts automatically
2. **Monitor your time** - View your playtime in an easy-to-read HH:MM:SS format
3. **Get notified** - Receive system notifications at your chosen interval
4. **Auto-reset** - Playtime resets automatically when your Mac sleeps or shuts down
5. **Manual reset** - Use the reset button anytime to start fresh

## 🛠️ Technical Implementation

### Architecture

The app follows modern SwiftUI best practices with a clean, modular architecture:

- **PlayTimeManager**: Core timer logic and playtime tracking (`PlayTimeManager.swift:1`)
- **SystemEventMonitor**: Monitors macOS sleep/wake events (`SystemEventMonitor.swift:1`)
- **NotificationManager**: Handles user notifications (`NotificationManager.swift:1`)
- **UserSettings**: Manages user preferences with `@AppStorage` (`UserSettings.swift:1`)
- **AppCoordinator**: Coordinates app lifecycle and system events (`PlayTimeTrackerApp.swift:24`)

### Key Technologies

- **SwiftUI**: For the declarative user interface
- **Combine**: For reactive state management
- **UserNotifications**: For system notification delivery
- **NSWorkspace**: For system event monitoring (sleep/wake detection)
- **@MainActor**: For safe concurrency and UI updates
- **@AppStorage**: For persistent user preferences

### System Event Handling

The app monitors several macOS events:
- `NSWorkspace.willSleepNotification` - Triggers playtime reset
- `NSWorkspace.didWakeNotification` - Resumes tracking
- `NSWorkspace.screensDidSleepNotification` - Handles screen sleep
- `NSWorkspace.screensDidWakeNotification` - Handles screen wake

## 📋 Requirements

- macOS 14.0 or later
- Xcode 15.0 or later (for development)

## 🚀 Getting Started

### Building from Source

1. Clone the repository
2. Open `PlayTimeTracker.xcodeproj` in Xcode
3. Build and run (⌘R)

### First Launch

On first launch, the app will request permission to send notifications. Click "Allow" to receive playtime updates.

## ⚙️ Configuration Options

### Notification Intervals

Choose from predefined intervals:
- 15 minutes
- 30 minutes (default)
- 60 minutes (1 hour)
- 90 minutes (1.5 hours)
- 120 minutes (2 hours)

### Notifications

Toggle notifications on/off at any time through the settings section in the app.

## 🎨 User Interface

The app features:
- Large, monospaced time display with gradient styling
- Desktop computer icon indicating laptop tracking
- Segmented control for interval selection
- Toggle switch for enabling/disabling notifications
- Status indicator showing tracking state
- Gradient reset button for quick playtime reset

## 🔒 Privacy & Security

- All data stays on your device - no network connections
- No data collection or tracking
- Minimal system permissions required
- Sandboxed app for enhanced security

## 📱 Future Enhancements

Potential features for future versions:
- Menu bar mode for always-visible tracking
- Daily/weekly usage statistics
- Break reminders
- Export usage data
- Dark mode optimizations
- Widget support

## 🤝 Contributing

Contributions are welcome! Feel free to submit issues and pull requests.

## 📄 License

This project is available for personal and educational use.

## 👨‍💻 Author

Created by 한시온

---

**Note**: This app is designed to help you be aware of your laptop usage time. Use it as a tool for better time management and digital wellness.
