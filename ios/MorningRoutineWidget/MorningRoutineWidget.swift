import WidgetKit
import SwiftUI

// MARK: - Data Provider

struct RoutineEntry: TimelineEntry {
    let date: Date
    let streak: Int
    let doneToday: Bool
    let scorePercent: Int
    let statusText: String
}

struct RoutineProvider: TimelineProvider {
    let userDefaults = UserDefaults(suiteName: "group.com.morningroutine.app")

    func placeholder(in context: Context) -> RoutineEntry {
        RoutineEntry(date: Date(), streak: 7, doneToday: false, scorePercent: 0, statusText: "À faire ce matin")
    }

    func getSnapshot(in context: Context, completion: @escaping (RoutineEntry) -> Void) {
        completion(makeEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<RoutineEntry>) -> Void) {
        let entry = makeEntry()
        // Refresh toutes les heures
        let nextUpdate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
        completion(timeline)
    }

    private func makeEntry() -> RoutineEntry {
        RoutineEntry(
            date: Date(),
            streak: userDefaults?.integer(forKey: "streak") ?? 0,
            doneToday: userDefaults?.bool(forKey: "doneToday") ?? false,
            scorePercent: userDefaults?.integer(forKey: "scorePercent") ?? 0,
            statusText: userDefaults?.string(forKey: "statusText") ?? "À faire ce matin"
        )
    }
}

// MARK: - Small Widget View

struct SmallWidgetView: View {
    let entry: RoutineEntry

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text("\(entry.streak)")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
            Text(entry.doneToday ? "Fait ✓" : "À faire")
                .font(.caption.weight(.semibold))
                .foregroundColor(entry.doneToday ? .green : Color(.systemGray))
        }
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

// MARK: - Medium Widget View

struct MediumWidgetView: View {
    let entry: RoutineEntry

    var motivation: String {
        if entry.streak == 0 { return "Lance ta routine !" }
        if entry.streak < 7 { return "Continue sur ta lancée !" }
        return "Tu es en feu !"
    }

    var body: some View {
        HStack(spacing: 16) {
            // Streak circle
            VStack(spacing: 2) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.15))
                        .frame(width: 56, height: 56)
                    VStack(spacing: 0) {
                        Image(systemName: "flame.fill")
                            .foregroundColor(.orange)
                            .font(.caption)
                        Text("\(entry.streak)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                    }
                }
                Text("jours")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            // Status
            VStack(alignment: .leading, spacing: 6) {
                Text("Morning Routine")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
                Text(entry.doneToday ? "Routine du jour ✓" : motivation)
                    .font(.subheadline.weight(.bold))
                    .foregroundColor(.primary)
                if entry.doneToday {
                    Text("Score : \(entry.scorePercent)%")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            Spacer()
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
    }
}

// MARK: - Lock Screen Views (iOS 16+)

@available(iOSApplicationExtension 16.0, *)
struct AccessoryCircularView: View {
    let entry: RoutineEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 1) {
                Image(systemName: "flame.fill")
                    .font(.caption2)
                Text("\(entry.streak)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
            }
        }
    }
}

@available(iOSApplicationExtension 16.0, *)
struct AccessoryRectangularView: View {
    let entry: RoutineEntry

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: entry.doneToday ? "checkmark.circle.fill" : "flame.fill")
                .foregroundColor(entry.doneToday ? .green : .orange)
            VStack(alignment: .leading, spacing: 0) {
                Text(entry.doneToday ? "Routine ✓" : "\(entry.streak) jours")
                    .font(.caption.weight(.bold))
                Text(entry.doneToday ? "Score \(entry.scorePercent)%" : "À faire ce matin")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Widget Entry View (dispatcher)

struct MorningRoutineWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: RoutineEntry

    var body: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            switch family {
            case .systemSmall:
                SmallWidgetView(entry: entry)
            case .systemMedium:
                MediumWidgetView(entry: entry)
            case .accessoryCircular:
                AccessoryCircularView(entry: entry)
            case .accessoryRectangular:
                AccessoryRectangularView(entry: entry)
            default:
                SmallWidgetView(entry: entry)
            }
        } else {
            switch family {
            case .systemSmall:
                SmallWidgetView(entry: entry)
            case .systemMedium:
                MediumWidgetView(entry: entry)
            default:
                SmallWidgetView(entry: entry)
            }
        }
    }
}

// MARK: - Widget Definition

struct MorningRoutineWidget: Widget {
    let kind: String = "MorningRoutineWidget"

    var body: some WidgetConfiguration {
        if #available(iOSApplicationExtension 16.0, *) {
            return StaticConfiguration(kind: kind, provider: RoutineProvider()) { entry in
                MorningRoutineWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("Morning Routine")
            .description("Ton streak et statut du jour.")
            .supportedFamilies([
                .systemSmall,
                .systemMedium,
                .accessoryCircular,
                .accessoryRectangular
            ])
        } else {
            return StaticConfiguration(kind: kind, provider: RoutineProvider()) { entry in
                MorningRoutineWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("Morning Routine")
            .description("Ton streak et statut du jour.")
            .supportedFamilies([
                .systemSmall,
                .systemMedium
            ])
        }
    }
}
