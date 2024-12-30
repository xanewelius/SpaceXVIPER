import Foundation

final class ShipDetailsAssembly {
    
    static func assembly(view: ShipDetailsView, with shipId: String, output: ShipDetailsModuleOutput?) -> ShipDetailsModuleInput {
        let apiService = ShipsAPIService()
        let cacheService = CacheService()
        let interactor = ShipDetailsInteractor(apiService: apiService, cacheService: cacheService)
        let router = ShipDetailsRouter(transitionHandler: view)
        let presenter = ShipDetailsPresenter(view: view, interactor: interactor, router: router, shipId: shipId)
        
        view.output = presenter
        interactor.output = presenter
        presenter.moduleOutput = output
        
        return presenter
    }
}
