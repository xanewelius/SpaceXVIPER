import UIKit
import SnapKit

final class HomeViewController: UIViewController, HomeView {
    
    // MARK: - Connections
    
    var output: HomeViewOutput!
    
    // MARK: - UI Components
    
    private let tableView = UITableView(frame: .zero)
    private let emptyView = EmptyView(frame: .zero)
    private let errorView = ErrorView(frame: .zero)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Data
    
    private var ships: [DisplayShip] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.viewDidLoad()
        embedViews()
        setupLayout()
        setupBehavior()
        setupAppearance()
    }
}

// MARK: - Embed views

private extension HomeViewController {
    
    func embedViews() {
        [
            tableView,
            emptyView,
            errorView,
            activityIndicator
        ].forEach {
            view.addSubview($0)
        }
    }
}

// MARK: - Setup layout

private extension HomeViewController {
    
    func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

// MARK: - Setup behavior

private extension HomeViewController {
    
    func setupBehavior() {
        tableView.register(ShipTableCell.self, forCellReuseIdentifier: ShipTableCell.cellID)
        
        emptyView.onRefresh = { [weak self] in
            self?.output.sendRequest()
        }
        
        errorView.onRetry = { [weak self] in
            self?.output.sendRequest()
        }
        
        tableView.estimatedRowHeight = 72
        
        tableView.dataSource = self
        tableView.delegate = self
        
        emptyView.isHidden = true
        errorView.isHidden = true
        activityIndicator.hidesWhenStopped = true
    }
}

// MARK: - Setup appearance

private extension HomeViewController {
    
    func setupAppearance() {
        title = "Ships"
        view.backgroundColor = .systemBackground
        tableView.backgroundColor = .systemBackground
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ships.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShipTableCell.cellID, for: indexPath) as? ShipTableCell else { return UITableViewCell() }
        
        let ship = ships[indexPath.row]
        cell.set(with: ship)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {}

// MARK: - HomeViewInput

extension HomeViewController {
    
    func set(state: HomeState) {
        switch state {
        case .loading:
            activityIndicator.startAnimating()
            self.ships = []
            emptyView.isHidden = true
            errorView.isHidden = true
            tableView.isHidden = true
        case .success(let ships):
            activityIndicator.stopAnimating()
            self.ships = ships
            emptyView.isHidden = true
            errorView.isHidden = true
            tableView.isHidden = false
            self.tableView.reloadData()
        case .error(let description):
            activityIndicator.stopAnimating()
            self.ships = []
            emptyView.isHidden = true
            errorView.isHidden = false
            tableView.isHidden = true
            updateErrorState(message: description)
        case .empty:
            activityIndicator.stopAnimating()
            self.ships = []
            emptyView.isHidden = false
            errorView.isHidden = true
            tableView.isHidden = true
        }
    }
    
    func showAccessCodeError() {
        let alert = UIAlertController(title: "Access Error", message: "There is a problem with the access code.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.output.sendRequest()
        })
        
        present(with: alert)
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}

// MARK: - Update error state

private extension HomeViewController {
    
    func updateErrorState(message: String) {
        let label = UILabel()
        label.text = message
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        
        errorView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
