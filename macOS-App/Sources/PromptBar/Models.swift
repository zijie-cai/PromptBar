import Foundation

struct Prompt: Identifiable, Codable {
    var id = UUID()
    var emoji: String
    var title: String
    var description: String
    var content: String
    var category: String
    var isFavorite: Bool
}
