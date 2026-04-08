import SwiftUI

struct CardView<Content: View>: View {
    var backgroundColor: Color = .white
    var cornerRadius: CGFloat = 16
    var shadowRadius: CGFloat = 4
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: .black.opacity(0.08), radius: shadowRadius, x: 0, y: 2)
    }
}

struct ProgressRing: View {
    let progress: Double
    var lineWidth: CGFloat = 8
    var size: CGFloat = 60
    var color: Color = .jsongRed

    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: CGFloat(min(progress, 1.0)))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)

            Text("\(Int(progress * 100))%")
                .font(.system(size: size * 0.22, weight: .bold, design: .rounded))
                .foregroundColor(color)
        }
        .frame(width: size, height: size)
    }
}

struct ModuleCard: View {
    let title: String
    let subtitle: String
    let sfSymbol: String
    let color: Color
    var progress: Double = 0

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 56, height: 56)
                Image(systemName: sfSymbol)
                    .font(.title2)
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if progress > 0 {
                ProgressRing(progress: progress, lineWidth: 5, size: 44, color: color)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
