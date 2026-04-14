import Foundation

struct ProblemContent: Codable {
    let id: String
    let title: String
    let difficulty: String
    let category: String
    let prerequisites: Prerequisites
    let concept: String
    let solutions: [Solution]
    let audioScript: AudioScript
}

struct Prerequisites: Codable {
    let phrases: [Phrase]?
    let technicalTerms: [TechnicalTerm]
    let javaMethods: [JavaMethod]

    /// All glossary entries for inline tap-to-reveal in dialogue text
    var allGlossaryKeys: [String: String] {
        var dict: [String: String] = [:]
        for p in phrases ?? [] {
            dict[p.phrase] = p.explanation
        }
        for t in technicalTerms {
            dict[t.term] = t.definition
        }
        for m in javaMethods {
            dict[m.signature] = m.description
        }
        return dict
    }
}

struct Phrase: Codable, Identifiable {
    var id: String { phrase }
    let phrase: String
    let explanation: String
}

struct JavaMethod: Codable, Identifiable {
    var id: String { signature }
    let signature: String
    let description: String
}

struct TechnicalTerm: Codable, Identifiable {
    var id: String { term }
    let term: String
    let definition: String
}

struct Solution: Codable, Identifiable {
    var id: Int { level }
    let level: Int
    let label: String
    let timeComplexity: String
    let spaceComplexity: String
    let summary: String
}

struct AudioScript: Codable {
    let sections: [AudioSection]
}

struct AudioSection: Codable, Identifiable {
    let id: String
    let level: Int
    let title: String
    let diagram: String?
    let lines: [DialogueLine]

    func diagramImageName(problemId: String) -> String? {
        guard diagram != nil else { return nil }
        return "\(problemId)-\(id)-diagram"
    }
}

struct DialogueLine: Codable, Identifiable {
    var id: String { audioFile }
    let speaker: Speaker
    let text: String
    let audioFile: String

    enum Speaker: String, Codable {
        case interviewer
        case candidate
    }
}
