import Foundation

struct ShipDetails {
    let shipId: String
    let shipName: String
    let shipModel: String?
    let shipType: String?
    let roles: [String]
    let active: Bool?
    let yearBuilt: Int?
    let homePort: String?
    let imageUrl: URL?
    let missions: [Mission]
}

struct Mission {
    let name: String
    let flight: Int
}
