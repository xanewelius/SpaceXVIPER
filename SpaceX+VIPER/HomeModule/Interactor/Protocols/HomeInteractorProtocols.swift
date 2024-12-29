import Foundation

protocol HomeInteractorInput: AnyObject {
    func obtainData()
}

protocol HomeInteractorOutput: AnyObject {
    func set(_ ships: [Ship])
    func handleError(_ error: Error)
}
