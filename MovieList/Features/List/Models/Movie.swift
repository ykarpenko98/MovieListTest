import Foundation

struct Movie: Hashable {
    let id: Int
    let title: String
    let genres: String
    let rate: Double
    let overview: String
    let posterImagePath: String?
    var cast: String?
}
