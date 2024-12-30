import Foundation

protocol ShipDetailsModuleInput: AnyObject {
    func configure(with ship: DisplayShip)
}

protocol ShipDetailsModuleOutput: AnyObject {
    func shipDetailsModule(shipId: String, didUpdateFavoriteStatus isFavorite: Bool)
}
