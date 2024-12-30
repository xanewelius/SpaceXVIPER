import Foundation

final class CacheService {
    
    // MARK: - Types
    
    enum Storage: String {
        case `default` = "xanew.SpaceX-VIPER"
    }
    
    private let service: UserDefaults
    
    // MARK: - Initializer
    
    init(storage: Storage = .default) {
        service = UserDefaults()
        service.addSuite(named: storage.rawValue)
    }
}

extension CacheService: CacheServiceType, CodableCacheServiceType {
    func remove(key: String) {
        service.removeObject(forKey: key)
    }
    
    func removeAll() {
        for (key, _) in service.dictionaryRepresentation() {
            remove(key: key)
        }
    }
    
    func write(_ string: String, for key: String) {
        service.set(string, forKey: key)
    }
    
    func read(for key: String) -> String? {
        service.string(forKey: key)
    }
    
    func write<T: Encodable>(_ value: T, for key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        service.set(data, forKey: key)
    }
    
    func read<T: Decodable>(for key: String) -> T? {
        guard
            let data = service.value(forKey: key) as? Data,
            let model = try? JSONDecoder().decode(T.self, from: data)
        else {
            return nil
        }
        return model
    }
}
