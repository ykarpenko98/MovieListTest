import Foundation

// MARK: - MoviePage
struct MovieCreditsModel: Codable {
    let id: Int
    let cast: [CastModel]
}

// MARK: - Cast
struct CastModel: Codable {
    let adult: Bool?
    let gender: Int?
    let id: Int?
    let knownForDepartment: DepartmentModel?
    let name: String
    let originalName: String?
    let popularity: Double?
    let profilePath: String?
    let castId: Int?
    let character: String?
    let creditId: String?
    let order: Int?

    enum CodingKeys: String, CodingKey {
        case adult = "adult"
        case gender = "gender"
        case id = "id"
        case knownForDepartment = "known_for_department"
        case name = "name"
        case originalName = "original_name"
        case popularity = "popularity"
        case profilePath = "profile_path"
        case castId = "cast_id"
        case character = "character"
        case creditId = "credit_id"
        case order = "order"
    }
}

enum DepartmentModel: String, Codable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case costumeMakeUp = "Costume & Make-Up"
    case crew = "Crew"
    case directing = "Directing"
    case editing = "Editing"
    case lighting = "Lighting"
    case production = "Production"
    case sound = "Sound"
    case visualEffects = "Visual Effects"
    case writing = "Writing"
}

extension MovieCreditsModel {
    var castDescription: String {
        var cast = cast.map { $0.name }.reduce("", { "\($0)\($1), "})
        if !cast.isEmpty {
            cast.removeLast(2)
        }
        return cast
    }
}
