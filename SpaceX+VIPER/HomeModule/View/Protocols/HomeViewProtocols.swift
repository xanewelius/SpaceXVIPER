import Foundation

protocol HomeViewInput: AnyObject {
    func set(state: HomeState)
    func showAccessCodeError()
    func hideActivityIndicator()
    func refreshShip(at index: Int)
}

protocol HomeViewOutput: AnyObject {
    var ships: [DisplayShip] { get set }
    
    func viewDidLoad()
    func sendRequest()
    func didSelectShip(id: String)
}

protocol HomeView: HomeViewInput, TransitionHandler {
    var output: HomeViewOutput! { get set }
}

// MARK: - HomeState

enum HomeState {
    case loading
    case success
    case error(String)
    case empty
}
