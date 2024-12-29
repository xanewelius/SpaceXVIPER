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
    
    func presentDetails() {
        print("HomeRouter: presentDetails")
    }
}
