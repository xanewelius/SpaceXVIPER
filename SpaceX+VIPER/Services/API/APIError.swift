import Foundation

enum APIError: Error {
    case invalidURL
    case invalidReponse(statusCode: Int)
    case decoding(Error)
    case network(Error)
}
