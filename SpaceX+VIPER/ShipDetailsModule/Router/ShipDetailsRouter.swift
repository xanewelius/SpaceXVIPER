import Foundation

final class ShipDetailsRouter {
    
    // MARK: - Connections
    
    private unowned var transitionHandler: TransitionHandler
    
    // MARK: - Initializer
    
    init(transitionHandler: TransitionHandler) {
        self.transitionHandler = transitionHandler
    }
}

// MARK: - ShipDetailsRouterInput

extension ShipDetailsRouter: ShipDetailsRouterInput {}
