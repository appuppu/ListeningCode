import AVFoundation
import MediaPlayer
import Observation

@Observable
final class AudioPlayerManager {
    var isPlaying = false
    var currentTime: Double = 0
    var duration: Double = 0
    var totalDuration: Double = 0
    var totalCurrentTime: Double = 0
    var playbackSpeed: Float = 1.0
    var currentLineIndex: Int = 0
    var currentSectionId: String?
    var currentLineId: String?
    var isAudioAvailable = false

    // Metadata for Now Playing
    var problemTitle: String = ""

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var endObserver: NSObjectProtocol?

    private var allLines: [DialogueLine] = []
    private var lineSectionMap: [String] = []
    private var lineDurations: [Double] = []
    private var allURLs: [URL?] = []
    private var didReachEnd = false

    func load(sections: [AudioSection], title: String = "") {
        problemTitle = title

        allLines = []
        lineSectionMap = []
        for section in sections {
            for line in section.lines {
                allLines.append(line)
                lineSectionMap.append(section.id)
            }
        }

        configureAudioSession()
        lineDurations = Array(repeating: 0, count: allLines.count)
        allURLs = allLines.map { audioURL(for: $0.audioFile) }

        Task {
            var anyAvailable = false
            for (i, url) in allURLs.enumerated() {
                if let url {
                    anyAvailable = true
                    let asset = AVURLAsset(url: url)
                    if let dur = try? await asset.load(.duration) {
                        self.lineDurations[i] = dur.seconds
                    }
                }
            }
            self.isAudioAvailable = anyAvailable
            self.totalDuration = self.lineDurations.reduce(0, +)

            if anyAvailable {
                self.setupPlayer()
                self.loadLine(at: 0)
                self.setupRemoteCommands()
                self.updateNowPlaying()
            }
        }
    }

    func togglePlayPause() {
        guard let player, isAudioAvailable else { return }

        if didReachEnd {
            loadLine(at: 0)
            didReachEnd = false
        }

        if isPlaying {
            player.pause()
        } else {
            player.rate = playbackSpeed
        }
        isPlaying.toggle()
        updateNowPlaying()
    }

    func skip(seconds: Double) {
        let targetGlobal = max(0, min(totalCurrentTime + seconds, totalDuration))
        seekGlobal(to: targetGlobal)
    }

    func seekGlobal(to globalSeconds: Double) {
        var accumulated: Double = 0
        for (i, dur) in lineDurations.enumerated() {
            if globalSeconds < accumulated + dur || i == lineDurations.count - 1 {
                let localTime = globalSeconds - accumulated
                if i != currentLineIndex {
                    loadLine(at: i)
                }
                player?.seek(to: CMTime(seconds: max(0, localTime), preferredTimescale: 600))
                didReachEnd = false
                updateNowPlaying()
                return
            }
            accumulated += dur
        }
    }

    func seekToSection(_ sectionIndex: Int, sections: [AudioSection]) {
        guard sectionIndex >= 0, sectionIndex < sections.count else { return }
        let targetSectionId = sections[sectionIndex].id
        guard let lineIndex = lineSectionMap.firstIndex(of: targetSectionId) else { return }
        loadLine(at: lineIndex)
        if isPlaying { player?.rate = playbackSpeed }
        updateNowPlaying()
    }

    func seekToLine(_ lineId: String) {
        guard let index = allLines.firstIndex(where: { $0.id == lineId }) else { return }
        loadLine(at: index)
        if isPlaying { player?.rate = playbackSpeed }
        updateNowPlaying()
    }

    func setSpeed(_ speed: Float) {
        playbackSpeed = speed
        if isPlaying { player?.rate = speed }
        updateNowPlaying()
    }

    func tearDown() {
        removeObservers()
        player?.pause()
        player = nil
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    // MARK: - Private

    private func setupPlayer() {
        player = AVPlayer()

        timeObserver = player?.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 0.1, preferredTimescale: 600),
            queue: .main
        ) { [weak self] time in
            guard let self else { return }
            self.currentTime = time.seconds
            self.updateTotalCurrentTime()
        }
    }

    private func loadLine(at index: Int) {
        guard index >= 0, index < allLines.count else { return }

        // Remove only the end observer (time observer stays on the player)
        if let obs = endObserver {
            NotificationCenter.default.removeObserver(obs)
            endObserver = nil
        }

        currentLineIndex = index
        currentLineId = allLines[index].id
        currentSectionId = lineSectionMap[index]

        guard let url = allURLs[index] else {
            duration = 0
            currentTime = 0
            return
        }

        let item = AVPlayerItem(url: url)
        player?.replaceCurrentItem(with: item)
        duration = lineDurations[index]
        currentTime = 0

        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { [weak self] _ in
            self?.onLineFinished()
        }
    }

    private func onLineFinished() {
        let nextIndex = currentLineIndex + 1
        if nextIndex < allLines.count {
            loadLine(at: nextIndex)
            if isPlaying {
                player?.rate = playbackSpeed
            }
            updateNowPlaying()
        } else {
            isPlaying = false
            didReachEnd = true
            updateNowPlaying()
        }
    }

    private func updateTotalCurrentTime() {
        let preceding = lineDurations.prefix(currentLineIndex).reduce(0, +)
        totalCurrentTime = preceding + currentTime
    }

    private func audioURL(for fileName: String) -> URL? {
        let name = fileName.replacingOccurrences(of: ".mp3", with: "")
        return Bundle.main.url(forResource: name, withExtension: "mp3")
    }

    private func removeObservers() {
        if let obs = timeObserver {
            player?.removeTimeObserver(obs)
            timeObserver = nil
        }
        if let obs = endObserver {
            NotificationCenter.default.removeObserver(obs)
            endObserver = nil
        }
    }

    private func configureAudioSession() {
        #if os(iOS)
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .spokenAudio)
        try? AVAudioSession.sharedInstance().setActive(true)
        #endif
    }

    // MARK: - Now Playing & Remote Commands

    private func updateNowPlaying() {
        #if os(iOS)
        var info = [String: Any]()
        info[MPMediaItemPropertyTitle] = problemTitle
        if currentLineIndex < allLines.count {
            let speaker = allLines[currentLineIndex].speaker == .interviewer ? "Interviewer" : "Candidate"
            info[MPMediaItemPropertyArtist] = speaker
        }
        info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = totalCurrentTime
        info[MPMediaItemPropertyPlaybackDuration] = totalDuration
        info[MPNowPlayingInfoPropertyPlaybackRate] = isPlaying ? playbackSpeed : 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
        #endif
    }

    private func setupRemoteCommands() {
        #if os(iOS)
        let center = MPRemoteCommandCenter.shared()

        center.playCommand.isEnabled = true
        center.playCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }

        center.pauseCommand.isEnabled = true
        center.pauseCommand.addTarget { [weak self] _ in
            self?.togglePlayPause()
            return .success
        }

        center.skipForwardCommand.isEnabled = true
        center.skipForwardCommand.preferredIntervals = [15]
        center.skipForwardCommand.addTarget { [weak self] _ in
            self?.skip(seconds: 15)
            return .success
        }

        center.skipBackwardCommand.isEnabled = true
        center.skipBackwardCommand.preferredIntervals = [15]
        center.skipBackwardCommand.addTarget { [weak self] _ in
            self?.skip(seconds: -15)
            return .success
        }

        center.changePlaybackPositionCommand.isEnabled = true
        center.changePlaybackPositionCommand.addTarget { [weak self] event in
            guard let event = event as? MPChangePlaybackPositionCommandEvent else { return .commandFailed }
            self?.seekGlobal(to: event.positionTime)
            return .success
        }
        #endif
    }
}
