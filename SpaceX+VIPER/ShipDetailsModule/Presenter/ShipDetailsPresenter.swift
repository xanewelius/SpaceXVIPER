import Foundation

final class ShipDetailsPresenter {
    
    // MARK: - Connections
    
    private unowned var view: ShipDetailsViewInput?
    
    private let interactor: ShipDetailsInteractorInput
    private let router: ShipDetailsRouterInput
    
    weak var moduleOutput: ShipDetailsModuleOutput?
    
    private var shipId: String
    private var isFavorite: Bool
    
    // MARK: - Initializer
    
    init(view: ShipDetailsViewInput, interactor: ShipDetailsInteractorInput, router: ShipDetailsRouterInput, shipId: String, isFavorite: Bool = false) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.shipId = shipId
        self.isFavorite = isFavorite
    }
}

// MARK: - ShipDetailsViewOutput

extension ShipDetailsPresenter: ShipDetailsViewOutput {
    
    func viewDidLoad() {
        interactor.fetchShipDetails(by: shipId)
    }
    
    func didTapFavoriteButton() {
        isFavorite.toggle()
        
        interactor.addToFavorite(isFavorite: isFavorite, shipId: shipId)
        moduleOutput?.shipDetailsModule(shipId: shipId, didUpdateFavoriteStatus: isFavorite)
        
        let buttonTitle = isFavorite ? "Remove from favorites" : "Add to favorites"
        view?.updateFavoriteButton(title: buttonTitle)
    }
}

// MARK: - ShipDetailsModuleInput

extension ShipDetailsPresenter: ShipDetailsModuleInput {
    
    func configure(with ship: DisplayShip) {
        view?.displayShipDetails(ship)
    }
}

// MARK: - ShipDetailsInteractorOutput

extension ShipDetailsPresenter: ShipDetailsInteractorOutput {
    
    func didFetchShipDetails(_ ship: Ship, isFavorite: Bool) {
        self.isFavorite = isFavorite
        view?.displayShipDetails(convertShip(from: ship))
    }
    
    func didFailToFetchShipDetails(with error: any Error) {
        view?.displayError(error.localizedDescription)
    }
    
    func convertShip(from ship: Ship) -> DisplayShip {
        DisplayShip(
            shipId: ship.shipId,
            shipName: ship.shipName,
            shipModel: "Model: \(ship.shipModel ?? "Unknown")",
            shipType: "Type: \(ship.shipType ?? "Unknown")",
            roles: "Roles: \(ship.roles?.joined(separator: ", ") ?? "Unknown")",
            active: ship.active ?? false ? "Active" : "Inactive",
            yearBuilt: "Year Built: \(ship.yearBuilt == nil ? "Unknown" : "\(ship.yearBuilt!)")",
            homePort: "Port: \(ship.homePort ?? "Unknown")",
            imageURL: ship.image.flatMap { URL(string: $0) },
            isFavorite: isFavorite
        )
    }
}
