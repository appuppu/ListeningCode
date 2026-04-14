import SwiftUI

struct TranscriptView: View {
    let problemId: String
    let sections: [AudioSection]
    let currentSectionId: String?
    let currentLineId: String?
    let glossary: [String: String]
    let onLineTap: (String) -> Void

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(sections) { section in
                        SectionCard(
                            section: section,
                            problemId: problemId,
                            isActiveSection: section.id == currentSectionId,
                            currentLineId: currentLineId,
                            glossary: glossary,
                            onLineTap: onLineTap
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .onChange(of: currentLineId) { _, newValue in
                guard let id = newValue else { return }
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(id, anchor: .top)
                }
            }
        }
    }
}

private struct SectionCard: View {
    let section: AudioSection
    let problemId: String
    let isActiveSection: Bool
    let currentLineId: String?
    let glossary: [String: String]
    let onLineTap: (String) -> Void
    @State private var showFullDiagram = false

    private var levelColor: Color {
        switch section.level {
        case 1: .blue
        case 2: .purple
        case 3: .orange
        default: .secondary
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if section.level > 0 {
                    Text("Level \(section.level)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(levelColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(levelColor.opacity(0.15), in: Capsule())
                }

                Text(section.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(isActiveSection ? .primary : .secondary)
            }

            if let imageName = section.diagramImageName(problemId: problemId),
               let uiImage = UIImage(named: imageName) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.vertical, 4)
                    .onTapGesture { showFullDiagram = true }
                    .fullScreenCover(isPresented: $showFullDiagram) {
                        DiagramFullScreenView(image: uiImage)
                    }
            }

            ForEach(section.lines) { line in
                DialogueLineView(
                    line: line,
                    isActive: line.id == currentLineId,
                    glossary: glossary,
                    onPlayTap: { onLineTap(line.id) }
                )
                .id(line.id)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isActiveSection ? Color.accentColor.opacity(0.06) : Color(.systemGray6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(isActiveSection ? Color.accentColor.opacity(0.3) : .clear, lineWidth: 1.5)
        )
    }
}

// MARK: - Dialogue Line

private struct DialogueLineView: View {
    let line: DialogueLine
    let isActive: Bool
    let glossary: [String: String]
    let onPlayTap: () -> Void
    @State private var selectedTerm: GlossaryEntry?

    struct GlossaryEntry: Identifiable {
        let id = UUID()
        let term: String
        let definition: String
    }

    private var speakerColor: Color {
        switch line.speaker {
        case .interviewer: .blue
        case .candidate: .green
        }
    }

    private var speakerIcon: String {
        switch line.speaker {
        case .interviewer: "person.fill.questionmark"
        case .candidate: "person.fill.checkmark"
        }
    }

    private var speakerLabel: String {
        switch line.speaker {
        case .interviewer: "Interviewer"
        case .candidate: "Candidate"
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: speakerIcon)
                .font(.caption)
                .foregroundStyle(speakerColor)
                .frame(width: 20)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(speakerLabel)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(speakerColor)

                    Spacer()

                    Button {
                        onPlayTap()
                    } label: {
                        Image(systemName: isActive ? "speaker.wave.2.fill" : "play.fill")
                            .font(.caption2)
                            .foregroundStyle(isActive ? speakerColor : .secondary)
                    }
                    .buttonStyle(.plain)
                }

                // Text with tappable glossary terms using AttributedString + link taps
                Text(buildAttributedText())
                    .font(.body)
                    .lineSpacing(4)
                    .environment(\.openURL, OpenURLAction { url in
                        if url.scheme == "glossary",
                           let term = url.host(percentEncoded: false),
                           let definition = glossary.first(where: {
                               $0.key.caseInsensitiveCompare(term) == .orderedSame
                           })?.value {
                            selectedTerm = GlossaryEntry(term: term, definition: definition)
                        }
                        return .handled
                    })
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isActive ? speakerColor.opacity(0.08) : .clear)
        )
        .sheet(item: $selectedTerm) { entry in
            GlossaryPopup(entry: entry)
        }
    }

    private func buildAttributedText() -> AttributedString {
        let textColor: Color = isActive ? .primary : .secondary
        let matches = findGlossaryMatches(in: line.text, glossary: glossary)

        if matches.isEmpty {
            var attr = AttributedString(line.text)
            attr.foregroundColor = textColor
            return attr
        }

        var result = AttributedString()
        var currentIndex = line.text.startIndex

        for match in matches {
            // Plain text before match
            if currentIndex < match.range.lowerBound {
                var plain = AttributedString(String(line.text[currentIndex..<match.range.lowerBound]))
                plain.foregroundColor = textColor
                result.append(plain)
            }

            // Glossary term as a tappable link
            let termText = String(line.text[match.range])
            var termAttr = AttributedString(termText)
            let encoded = match.term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? match.term
            termAttr.link = URL(string: "glossary://\(encoded)")
            termAttr.foregroundColor = .accentColor
            termAttr.underlineStyle = .single
            result.append(termAttr)

            currentIndex = match.range.upperBound
        }

        // Remaining text
        if currentIndex < line.text.endIndex {
            var remaining = AttributedString(String(line.text[currentIndex...]))
            remaining.foregroundColor = textColor
            result.append(remaining)
        }

        return result
    }
}

// MARK: - Glossary Popup

private struct GlossaryPopup: View {
    let entry: DialogueLineView.GlossaryEntry
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(entry.term)
                    .font(.headline)
                Spacer()
                Button { dismiss() } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }

            Text(entry.definition)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .presentationDetents([.height(160)])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Full Screen Diagram

private struct DiagramFullScreenView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    MagnifyGesture()
                        .onChanged { value in
                            scale = lastScale * value.magnification
                        }
                        .onEnded { value in
                            lastScale = max(1.0, scale)
                            scale = lastScale
                            if scale == 1.0 {
                                offset = .zero
                                lastOffset = .zero
                            }
                        }
                        .simultaneously(with:
                            DragGesture()
                                .onChanged { value in
                                    offset = CGSize(
                                        width: lastOffset.width + value.translation.width,
                                        height: lastOffset.height + value.translation.height
                                    )
                                }
                                .onEnded { _ in
                                    lastOffset = offset
                                }
                        )
                )
                .onTapGesture(count: 2) {
                    withAnimation {
                        if scale > 1.0 {
                            scale = 1.0
                            lastScale = 1.0
                            offset = .zero
                            lastOffset = .zero
                        } else {
                            scale = 3.0
                            lastScale = 3.0
                        }
                    }
                }

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .foregroundStyle(.white.opacity(0.8))
                    .padding()
            }
        }
    }
}

// MARK: - Glossary Matching

private struct GlossaryMatch: Comparable {
    let term: String
    let definition: String
    let range: Range<String.Index>

    static func < (lhs: GlossaryMatch, rhs: GlossaryMatch) -> Bool {
        lhs.range.lowerBound < rhs.range.lowerBound
    }
}

private func findGlossaryMatches(in text: String, glossary: [String: String]) -> [GlossaryMatch] {
    var matches: [GlossaryMatch] = []
    let lowered = text.lowercased()

    for (term, definition) in glossary {
        let termLower = term.lowercased()
        var searchStart = lowered.startIndex
        while let range = lowered.range(of: termLower, range: searchStart..<lowered.endIndex) {
            matches.append(GlossaryMatch(term: term, definition: definition, range: range))
            searchStart = range.upperBound
        }
    }

    matches.sort { a, b in
        if a.range.lowerBound == b.range.lowerBound {
            return a.term.count > b.term.count
        }
        return a < b
    }

    var filtered: [GlossaryMatch] = []
    var lastEnd = text.startIndex
    for match in matches {
        if match.range.lowerBound >= lastEnd {
            filtered.append(match)
            lastEnd = match.range.upperBound
        }
    }
    return filtered
}
