import Foundation

final class HomeAssembly {
    
    static func assembly(with view: HomeView) {
        let apiService = ShipsAPIService()
        let cacheService = CacheService()
        let interactor = HomeInteractor(apiService: apiService, cacheService: cacheService)
        let router = HomeRouter(transitionHandler: view)
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)
        
        view.output = presenter
        interactor.output = presenter
    }
}
