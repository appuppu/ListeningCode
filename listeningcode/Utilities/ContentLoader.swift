import Foundation

enum ContentLoader {
    static func loadCategories() -> [LCCategory] {
        load("categories") ?? []
    }

    static func loadProblems(forCategory id: String) -> [LCProblem] {
        load("\(id)-problems") ?? []
    }

    static func loadProblemContent(category: String, problem: String) -> ProblemContent? {
        load(problem)
    }

    private static func load<T: Decodable>(_ resource: String) -> T? {
        guard let url = Bundle.main.url(
            forResource: resource,
            withExtension: "json"
        ) else { return nil }

        guard let data = try? Data(contentsOf: url) else { return nil }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try? decoder.decode(T.self, from: data)
    }
}
