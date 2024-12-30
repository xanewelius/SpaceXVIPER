import Foundation

final class HomeInteractor {
    
    // MARK: - Connections
    
    weak var output: HomeInteractorOutput?
    
    // MARK: - Services
    
    private let apiService: APIServiceType
    private let cacheService: CodableCacheServiceType
    
    // MARK: - Initializer
    
    init(apiService: APIServiceType, cacheService: CodableCacheServiceType) {
        self.apiService = apiService
        self.cacheService = cacheService
    }
}

// MARK: - HomeInteractorInput

extension HomeInteractor: HomeInteractorInput {
    
    func isFavorite(from shipId: String) -> Bool {
        cacheService.read(for: shipId) ?? false
    }
    
    func obtainData() {
        Task {
            do {
                let data = try await apiService.fetchShips()
                
                await MainActor.run {
                    output?.set(data)
                }
            } catch {
                await MainActor.run {
                    output?.handleError(error)
                }
            }
        }
        
    }
}
