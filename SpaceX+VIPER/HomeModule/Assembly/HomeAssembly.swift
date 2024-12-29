import Foundation

final class HomeAssembly {
    
    static func assembly(with view: HomeView) {
        let apiService = ShipsAPIService()
        let interactor = HomeInteractor(apiService: apiService)
        let router = HomeRouter(transitionHandler: view)
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)
        
        view.output = presenter
        interactor.output = presenter
    }
}
