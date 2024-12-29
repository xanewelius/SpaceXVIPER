import Foundation

final class HomeInteractor {
    
    // MARK: - Connections
    
    weak var output: HomeInteractorOutput?
    
    // MARK: - Services
    
    private let apiService: APIServiceType
    
    // MARK: - Initializer
    
    init(apiService: APIServiceType) {
        self.apiService = apiService
    }
}

// MARK: - HomeInteractorInput

extension HomeInteractor: HomeInteractorInput {
    
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
