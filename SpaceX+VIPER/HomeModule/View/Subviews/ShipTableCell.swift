import UIKit
import SnapKit
import Kingfisher

final class ShipTableCell: UITableViewCell {
    
    // MARK: - ID
    
    static let cellID = "ShipUITableViewCell"
    
    // MARK: - UI Components
    
    private let shipImageView = UIImageView(frame: .zero)
    private let favoriteImageView = UIImageView(frame: .zero)
    
    private let nameLabel = UILabel(frame: .zero)
    private let modelLabel = UILabel(frame: .zero)
    private let typeLabel = UILabel(frame: .zero)
    private let rolesLabel = UILabel(frame: .zero)
    private let statusLabel = UILabel(frame: .zero)
    private let yearBuiltLabel = UILabel(frame: .zero)
    private let homePortLabel = UILabel(frame: .zero)
    
    private let infoStackView = UIStackView(frame: .zero)
    private let mainStackView = UIStackView(frame: .zero)
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        shipImageView.image = nil
        favoriteImageView.image = nil
        
        shipImageView.kf.cancelDownloadTask()
        
        nameLabel.text = nil
        modelLabel.text = nil
        typeLabel.text = nil
        rolesLabel.text = nil
        statusLabel.text = nil
        yearBuiltLabel.text = nil
        homePortLabel.text = nil
    }
}

// MARK: -

private extension ShipTableCell {
    func setupUI() {
        embedViews()
        setupStackAppearance()
        setupLayout()
        setupAppearance()
    }
}

// MARK: - Embed views

private extension ShipTableCell {
    
    func embedViews() {
        contentView.addSubview(mainStackView)
        
        [
            nameLabel,
            modelLabel,
            typeLabel,
            rolesLabel,
            statusLabel,
            yearBuiltLabel,
            homePortLabel,
            favoriteImageView
        ].forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        mainStackView.addArrangedSubview(shipImageView)
        mainStackView.addArrangedSubview(infoStackView)
    }
}

// MARK: - Setup stack appearance

private extension ShipTableCell {
    
    func setupStackAppearance() {
        infoStackView.axis = .vertical
        infoStackView.spacing = 4
        infoStackView.alignment = .leading
        infoStackView.distribution = .equalSpacing
        
        mainStackView.axis = .horizontal
        mainStackView.spacing = 12
        mainStackView.alignment = .top
        mainStackView.distribution = .fill
    }
}

// MARK: - Setup layout

private extension ShipTableCell {
    
    func setupLayout() {
        mainStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        shipImageView.snp.makeConstraints { make in
            make.width.equalTo(shipImageView.snp.height)
            make.width.equalTo(100)
        }
    }
}

// MARK: - Setup appearance

private extension ShipTableCell {
    
    func setupAppearance() {
        contentView.backgroundColor = .secondarySystemBackground
        
        shipImageView.contentMode = .scaleAspectFill
        shipImageView.clipsToBounds = true
        shipImageView.layer.cornerRadius = 8
        
        nameLabel.font = .boldSystemFont(ofSize: 18)
        nameLabel.textColor = .label
        
        [
            modelLabel,
            typeLabel,
            rolesLabel,
            yearBuiltLabel,
            homePortLabel
        ].forEach {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .secondaryLabel
        }
        
        rolesLabel.numberOfLines = 0
        
        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.textColor = .systemGreen
    }
}

// MARK: - Set data

extension ShipTableCell {
    
    func set(with ship: DisplayShip) {
        nameLabel.text = ship.shipName
        modelLabel.text = ship.shipModel
        typeLabel.text = ship.shipType
        rolesLabel.text = ship.roles
        statusLabel.text = ship.active
        
        // FIXME: - Delete .textColor
        statusLabel.textColor = ship.active == "Active" ? .systemGreen : .systemRed
        
        yearBuiltLabel.text = ship.yearBuilt
        homePortLabel.text = ship.homePort
        
        if let image = ship.imageURL {
            shipImageView.kf.setImage(
                with: image,
                placeholder: UIImage(systemName: "photo"),
                options: [.transition(.fade(0.3)), .cacheOriginalImage]
            )
        } else {
            shipImageView.image = UIImage(systemName: "photo")
        }
        
        if ship.isFavorite {
            favoriteImageView.image = UIImage(systemName: "star.fill")
        }
    }
}
