import Foundation

// MARK: - GenresList
struct GenresListModel: Codable {
    let genres: [GenreModel]
}

// MARK: - Genre
struct GenreModel: Codable {
    let id: Int
    let name: String
}
