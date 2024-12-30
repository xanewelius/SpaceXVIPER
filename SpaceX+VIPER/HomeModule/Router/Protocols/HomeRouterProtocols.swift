import Foundation

protocol HomeRouterInput: AnyObject {
    func presentDetails(with shipId: String, presenter: HomePresenter) -> ShipDetailsModuleInput
}
