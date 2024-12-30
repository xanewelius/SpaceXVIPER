import Foundation

protocol ShipDetailsViewInput: AnyObject {
    func displayShipDetails(_ details: DisplayShip)
    func displayError(_ message: String)
    func updateFavoriteButton(title: String)
}

protocol ShipDetailsViewOutput: AnyObject {
    func viewDidLoad()
    func didTapFavoriteButton()
}

protocol ShipDetailsView: ShipDetailsViewInput, TransitionHandler {
    var output: ShipDetailsViewOutput! { get set }
}
