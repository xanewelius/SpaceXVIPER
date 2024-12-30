import UIKit

final class ShipDetailsViewController: UIViewController, ShipDetailsView {
    
    // MARK: - Connections
    
    var output: ShipDetailsViewOutput!
    
    // MARK: - UI Components
    
    private let imageView = UIImageView(frame: .zero)
    private let nameLabel = UILabel(frame: .zero)
    private let infoStackView = UIStackView(frame: .zero)
    
    private let modelLabel = UILabel(frame: .zero)
    private let typeLabel = UILabel(frame: .zero)
    private let rolesLabel = UILabel(frame: .zero)
    private let statusLabel = UILabel(frame: .zero)
    private let yearBuiltLabel = UILabel(frame: .zero)
    private let homePortLabel = UILabel(frame: .zero)
    private let missionsLabel = UILabel(frame: .zero)
    
    private let favoriteButton = UIButton(type: .system)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        output.viewDidLoad()
    }
}

// MARK: - Setup UI

private extension ShipDetailsViewController {
    
    func setupUI() {
        embedViews()
        setupStackAppearance()
        setupLayout()
        setupBehavior()
        setupAppearance()
    }
}

// MARK: - Embed views

private extension ShipDetailsViewController {
    
    func embedViews() {
        [imageView, nameLabel, favoriteButton, infoStackView].forEach {
            view.addSubview($0)
        }
        
        [
            modelLabel,
            typeLabel,
            rolesLabel,
            statusLabel,
            yearBuiltLabel,
            homePortLabel,
            missionsLabel
        ].forEach {
            infoStackView.addArrangedSubview($0)
        }
    }
}

// MARK: - Setup stack appearance

private extension ShipDetailsViewController {
    
    func setupStackAppearance() {
        infoStackView.axis = .vertical
        infoStackView.spacing = 4
        infoStackView.alignment = .leading
        infoStackView.distribution = .equalSpacing
    }
}

// MARK: - Setup layout

private extension ShipDetailsViewController {
    
    func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(200)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        favoriteButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        infoStackView.snp.makeConstraints { make in
            make.top.equalTo(favoriteButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Setup behavior

private extension ShipDetailsViewController {
    
    func setupBehavior() {
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Setup appearance

private extension ShipDetailsViewController {
    
    func setupAppearance() {
        view.backgroundColor = .systemBackground
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        
        let labels = [modelLabel, typeLabel, rolesLabel, statusLabel, yearBuiltLabel, homePortLabel, missionsLabel]
        
        labels.forEach { label in
            label.font = .systemFont(ofSize: 16)
            label.textColor = .label
            label.numberOfLines = 0
        }
        
        statusLabel.font = .systemFont(ofSize: 16)
        statusLabel.numberOfLines = 0
        
        favoriteButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
    }
}

// MARK: - Actions

private extension ShipDetailsViewController {
    
    @objc
    func favoriteButtonTapped() {
        output.didTapFavoriteButton()
    }
}

// MARK: - ShipDetailsViewInput

extension ShipDetailsViewController: ShipDetailsViewInput {
    
    func displayShipDetails(_ details: DisplayShip) {
        navigationItem.title = details.shipName
        
        nameLabel.text = details.shipName
        modelLabel.text = details.shipModel
        typeLabel.text = details.shipType
        rolesLabel.text = details.roles
        statusLabel.text = details.active
        
        // FIXME: - Delete .textColor
        statusLabel.textColor = details.active == "Active" ? .systemGreen : .systemRed
        
        yearBuiltLabel.text = details.yearBuilt
        homePortLabel.text = details.homePort
        
        if let imageURL = details.imageURL {
            imageView.kf.setImage(
                with: imageURL,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.3)), .cacheOriginalImage]
            )
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
        
        let buttonTitle = details.isFavorite ? "Remove from favorites" : "Add to favorites"
        favoriteButton.setTitle(buttonTitle, for: .normal)
    }
    
    func displayError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func updateFavoriteButton(title: String) {
        favoriteButton.setTitle(title, for: .normal)
    }
}
