import Foundation

struct NetworkRequest {
    let url: URL
    let method: HTTPMethod
    let headers: [String: String]?
    let body: Data?
}
