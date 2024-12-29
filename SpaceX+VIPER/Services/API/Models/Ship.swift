import Foundation

struct Ship: Codable {
    let shipId: String
    let shipName: String
    let shipModel: String?
    let shipType: String?
    let roles: [String]?
    let active: Bool?
    let yearBuilt: Int?
    let homePort: String?
    let image: String?
}
