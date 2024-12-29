import Foundation

final class HomePresenter {
    
    // MARK: - Connections
    
    private unowned var view: HomeViewInput
    
    private let interactor: HomeInteractorInput
    private let router: HomeRouterInput
    
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
}

// MARK: - HomeInteractorOutput

extension HomePresenter: HomeInteractorOutput {
    
    func set(_ ships: [Ship]) {
        if ships.isEmpty {
            view.set(state: .empty)
        } else {
            view.set(state: .success(ships.map { convertShip(from: $0) }))
        }
    }
    
    func convertShip(from ship: Ship) -> DisplayShip {
        DisplayShip(
            shipId: ship.shipId,
            shipName: ship.shipName,
            shipModel: ship.shipModel ?? "Unknown",
            shipType: ship.shipType ?? "Unknown",
            roles: ship.roles?.joined(separator: ", ") ?? "Unknown",
            active: ship.active ?? false ? "Active" : "Inactive",
            yearBuilt: ship.yearBuilt == nil ? "Year Built: Unknown" : "Year Built: \(ship.yearBuilt!)",
            homePort: ship.homePort ?? "Unknown",
            imageURL: ship.image.flatMap { URL(string: $0) }
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
