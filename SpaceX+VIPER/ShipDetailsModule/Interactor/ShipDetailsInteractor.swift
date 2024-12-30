import Foundation

final class ShipDetailsInteractor {
    // MARK: - Connections
    
    weak var output: ShipDetailsInteractorOutput?
    private let cacheService: CodableCacheServiceType
    
    // MARK: - Services
    
    private let apiService: APIServiceType
    
    // MARK: - Initializer
    
    init(apiService: APIServiceType, cacheService: CodableCacheServiceType) {
        self.apiService = apiService
        self.cacheService = cacheService
    }
}

// MARK: - ShipDetailsInteractorInput

extension ShipDetailsInteractor: ShipDetailsInteractorInput {
    
    func fetchShipDetails(by id: String) {
        Task {
            do {
                let ship = try await apiService.fetchShipDetails(by: id)
                let isFavorite = cacheService.read(for: ship.shipId) ?? false
                
                await MainActor.run {
                    output?.didFetchShipDetails(ship, isFavorite: isFavorite)
                }
            } catch {
                await MainActor.run {
                    output?.didFailToFetchShipDetails(with: error)
                }
            }
        }
    }
    
    func addToFavorite(isFavorite: Bool, shipId: String) {
        cacheService.write(isFavorite, for: shipId)
    }
}
