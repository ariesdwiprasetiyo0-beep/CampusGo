import SwiftUI

// MARK: - App Accent Color
// Single accent: system indigo — maps to .indigo in both light & dark mode.
// Change once here to update the entire app.
extension Color {
    static let appAccent = Color.indigo
}

// MARK: - Loading View
/// Full-screen native loading indicator, HIG-compliant.
struct LoadingView: View {
    var message: String = "Memuat..."

    var body: some View {
        ContentUnavailableView {
            Label {
                Text(message)
            } icon: {
                ProgressView()
                    .controlSize(.large)
                    .tint(.appAccent)
            }
        }
    }
}

// MARK: - Error View
struct ErrorView: View {
    let message: String
    let action: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Terjadi Kesalahan", systemImage: "exclamationmark.triangle.fill")
        } description: {
            Text(message)
        } actions: {
            Button(action: action) {
                Label("Coba Lagi", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.borderedProminent)
            .tint(.appAccent)
        }
    }
}

// MARK: - Empty State View
struct EmptyStateView: View {
    let message: String
    var icon: String = "tray.fill"

    var body: some View {
        ContentUnavailableView(message, systemImage: icon)
    }
}

// MARK: - Category Badge
/// A compact, pill-shaped category label using system colors.
struct CategoryBadge: View {
    let title: String
    let color: Color

    var body: some View {
        Text(title)
            .font(.caption2.weight(.semibold))
            .textCase(.uppercase)
            .tracking(0.5)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.12), in: Capsule())
            .overlay(Capsule().strokeBorder(color.opacity(0.2), lineWidth: 0.5))
    }
}
