import Foundation

protocol ShipDetailsInteractorInput: AnyObject {
    func fetchShipDetails(by id: String)
    func addToFavorite(isFavorite: Bool, shipId: String)
}

protocol ShipDetailsInteractorOutput: AnyObject {
    func didFetchShipDetails(_ ship: Ship, isFavorite: Bool)
    func didFailToFetchShipDetails(with error: Error)
}
