import SwiftUI

struct AudioControlsView: View {
    @Bindable var audioManager: AudioPlayerManager

    private let speeds: [Float] = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]

    var body: some View {
        HStack(spacing: 0) {
            // Time
            Text(TimeFormatting.format(audioManager.totalCurrentTime))
                .font(.caption2)
                .foregroundStyle(.secondary)
                .monospacedDigit()
                .frame(width: 32, alignment: .leading)

            // Slider
            Slider(
                value: Binding(
                    get: { audioManager.totalCurrentTime },
                    set: { audioManager.seekGlobal(to: $0) }
                ),
                in: 0...max(audioManager.totalDuration, 1)
            )
            .tint(.accentColor)
            .padding(.horizontal, 6)

            // Time
            Text(TimeFormatting.format(audioManager.totalDuration))
                .font(.caption2)
                .foregroundStyle(.secondary)
                .monospacedDigit()
                .frame(width: 32, alignment: .trailing)

            // Controls
            HStack(spacing: 14) {
                Menu {
                    ForEach(speeds, id: \.self) { speed in
                        Button {
                            audioManager.setSpeed(speed)
                        } label: {
                            HStack {
                                Text(speedLabel(speed))
                                if audioManager.playbackSpeed == speed {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    Text(speedLabel(audioManager.playbackSpeed))
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.accentColor)
                }

                Button { audioManager.skip(seconds: -15) } label: {
                    Image(systemName: "gobackward.15")
                        .font(.caption)
                }

                Button { audioManager.togglePlayPause() } label: {
                    Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 40))
                }

                Button { audioManager.skip(seconds: 15) } label: {
                    Image(systemName: "goforward.15")
                        .font(.caption)
                }
            }
            .foregroundStyle(.primary)
            .padding(.leading, 8)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
    }

    private func speedLabel(_ speed: Float) -> String {
        if speed == Float(Int(speed)) {
            return "\(Int(speed)).0x"
        }
        return String(format: "%.1fx", speed)
    }
}
