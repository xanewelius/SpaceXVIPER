import Foundation

protocol HomeInteractorInput: AnyObject {
    func obtainData()
    func isFavorite(from shipId: String) -> Bool
}

protocol HomeInteractorOutput: AnyObject {
    func set(_ ships: [Ship])
    func handleError(_ error: Error)
}
