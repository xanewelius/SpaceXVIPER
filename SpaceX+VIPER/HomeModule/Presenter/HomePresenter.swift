import Foundation

final class HomePresenter {
    
    // MARK: - Connections
    
    private unowned var view: HomeViewInput
    
    private let interactor: HomeInteractorInput
    private let router: HomeRouterInput
    
    private weak var detailedScreen: ShipDetailsModuleInput?
    
    var ships: [DisplayShip] = []
    
    // MARK: - Initializer
    
    init(view: HomeViewInput, interactor: HomeInteractorInput, router: HomeRouterInput) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - HomeViewOutput

extension HomePresenter: HomeViewOutput {
    
    func viewDidLoad() {
        view.set(state: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.interactor.obtainData()
        }
    }
    
    func sendRequest() {
        view.set(state: .loading)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.interactor.obtainData()
        }
    }
    
    func didSelectShip(id: String) {
        detailedScreen = router.presentDetails(with: id, presenter: self)
    }
}

// MARK: - HomeInteractorOutput

extension HomePresenter: HomeInteractorOutput {
    
    func set(_ ships: [Ship]) {
        if ships.isEmpty {
            view.set(state: .empty)
        } else {
            self.ships = ships.map { convertShip(from: $0) }
            view.set(state: .success)
        }
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
            isFavorite: interactor.isFavorite(from: ship.shipId)
        )
    }
    
    func handleError(_ error: any Error) {
        let state: HomeState
        
        if let apiError = error as? APIError {
            switch apiError {
            case .invalidURL:
                state = .error("Invalid URL")
            case .invalidReponse(let statusCode):
                if statusCode == 401 {
                    view.showAccessCodeError()
                    view.hideActivityIndicator()
                    return
                } else {
                    state = .error("Invalid response, status code: \(statusCode)")
                }
            case .decoding(let decodingError):
                state = .error("Decoding error: \(decodingError.localizedDescription)")
            case .network(let error):
                state = .error("Network error: \(error.localizedDescription)")
            }
        } else {
            state = .error("Unknown error: \(error.localizedDescription)")
        }
        
        view.set(state: state)
    }
}

// MARK: - ShipDetailsModuleOutput

extension HomePresenter: ShipDetailsModuleOutput {
    
    func shipDetailsModule(shipId: String, didUpdateFavoriteStatus isFavorite: Bool) {
        if let index = ships.firstIndex(where: { $0.shipId == shipId }) {
            ships[index].isFavorite = isFavorite
            view.refreshShip(at: index)
        }
    }
}
