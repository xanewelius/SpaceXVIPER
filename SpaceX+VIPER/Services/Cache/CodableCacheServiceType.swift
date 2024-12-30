import Foundation

protocol CodableCacheServiceType {
    func write<T: Encodable>(_ value: T, for key: String)
    func read<T: Decodable>(for key: String) -> T?
}
