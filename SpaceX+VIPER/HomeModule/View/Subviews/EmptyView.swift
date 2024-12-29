import UIKit
import SnapKit

final class EmptyView: UIView {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let subtitleLabel = UILabel(frame: .zero)
    private let actionButton = UIButton(frame: .zero)
    
    // MARK: - Callback
    
    var onRefresh: (() -> Void)?
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        embedViews()
        setupLayout()
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Embed views

private extension EmptyView {
    
    func embedViews() {
        [
            imageView,
            titleLabel,
            subtitleLabel,
            actionButton
        ].forEach {
            addSubview($0)
        }
    }
}

// MARK: - Setup layout

private extension EmptyView {
    
    func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-80)
            make.width.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
    }
}

// MARK: - Setup appearance

private extension EmptyView {
    
    func setupAppearance() {
        imageView.image = UIImage(systemName: "person.crop.circle.badge.exclamationmark")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemBlue
        
        titleLabel.text = "No Ships Available"
        titleLabel.font = .boldSystemFont(ofSize: 24)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        
        subtitleLabel.text = "Please check back later or refresh to see if new ships are available"
        subtitleLabel.font = .systemFont(ofSize: 16)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        
        actionButton.setTitle("Refresh", for: .normal)
        actionButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = .systemBlue
        actionButton.layer.cornerRadius = 22
        actionButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Actions

private extension EmptyView {
    @objc
    func refreshButtonTapped() {
        onRefresh?()
    }
}
