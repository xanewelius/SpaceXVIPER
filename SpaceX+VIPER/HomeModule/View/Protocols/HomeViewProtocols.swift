import Foundation

protocol HomeViewInput: AnyObject {
    func set(state: HomeState)
    func showAccessCodeError()
    func hideActivityIndicator()
}

protocol HomeViewOutput: AnyObject {
    func viewDidLoad()
    func sendRequest()
}

protocol HomeView: HomeViewInput, TransitionHandler {
    var output: HomeViewOutput! { get set }
}

// MARK: - HomeState

enum HomeState {
    case loading
    case success([DisplayShip])
    case error(String)
    case empty
}
