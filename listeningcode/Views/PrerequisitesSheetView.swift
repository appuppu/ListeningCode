import SwiftUI

struct PrerequisitesSheetView: View {
    let prerequisites: Prerequisites
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                if let phrases = prerequisites.phrases, !phrases.isEmpty {
                    Section {
                        ForEach(phrases) { phrase in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(phrase.phrase)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text(phrase.explanation)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    } header: {
                        Label("Phrases", systemImage: "text.quote")
                    }
                }

                if !prerequisites.technicalTerms.isEmpty {
                    Section {
                        ForEach(prerequisites.technicalTerms) { term in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(term.term)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                Text(term.definition)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    } header: {
                        Label("Technical Terms", systemImage: "book")
                    }
                }

                if !prerequisites.javaMethods.isEmpty {
                    Section {
                        ForEach(prerequisites.javaMethods) { method in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(method.signature)
                                    .font(.subheadline.monospaced())
                                    .foregroundStyle(Color.accentColor)
                                Text(method.description)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    } header: {
                        Label("Java Methods", systemImage: "chevron.left.forwardslash.chevron.right")
                    }
                }
            }
            .navigationTitle("Prerequisites")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
