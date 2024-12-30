import Foundation

enum SpaceXEndpoint: Endpoint {
    case ships
    case shipDetails(id: String)
    case createShip(shipData: Ship)
    
    var path: String {
        switch self {
        case .ships:
            "/v3/ships"
        case .shipDetails(id: let id):
            "/v3/ships/\(id)"
        case .createShip:
            "/v3/ships"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .ships, .shipDetails: .GET
        case .createShip: .POST
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    
    var body: Data? {
        switch self {
        case .createShip(let ship):
            try? JSONEncoder().encode(ship)
        default:
            nil
        }
    }
}
