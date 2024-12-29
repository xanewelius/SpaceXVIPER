import UIKit

protocol TransitionHandler: AnyObject {
    func present(with viewController: UIViewController, animated: Bool)
    func dismiss(animated: Bool)
}

extension TransitionHandler where Self: UIViewController {
    func present(with viewController: UIViewController, animated: Bool = true) {
        present(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool = true) {
        dismiss(animated: animated)
    }
}
