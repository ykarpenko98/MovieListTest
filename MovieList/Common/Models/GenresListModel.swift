import Foundation

// MARK: - GenresList
struct GenresListModel: Codable {
    let genres: [GenreModel]

    enum CodingKeys: String, CodingKey {
        case genres = "genres"
    }
}

// MARK: - Genre
struct GenreModel: Codable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}
