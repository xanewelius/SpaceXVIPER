import Foundation

final class HomeRouter {
    
    // MARK: - Connections
    
    private unowned var transitionHandler: TransitionHandler
    
    // MARK: - Initializer
    
    init(transitionHandler: TransitionHandler) {
        self.transitionHandler = transitionHandler
    }
}

// MARK: - HomeRouterInput

extension HomeRouter: HomeRouterInput {
    
    func presentDetails(with shipId: String, presenter: HomePresenter) -> ShipDetailsModuleInput {
        let view = ShipDetailsViewController()
        let module = ShipDetailsAssembly.assembly(view: view, with: shipId, output: presenter)
        transitionHandler.present(with: view, animated: true)
        
        return module
    }
}
