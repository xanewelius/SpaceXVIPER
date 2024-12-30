import Foundation

protocol CacheServiceType: AnyObject {
    func remove(key: String)
    func removeAll()
    func write(_ string: String, for key: String)
    func read(for key: String) -> String?
}
