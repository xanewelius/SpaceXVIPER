import UIKit
import SnapKit

final class ErrorView: UIView {
    
    // MARK: - UI Components
    
    private let imageView = UIImageView(frame: .zero)
    private let titleLabel = UILabel(frame: .zero)
    private let messageLabel = UILabel(frame: .zero)
    private let retryButton = UIButton(frame: .zero)
    
    // MARK: - Callback
    
    var onRetry: (() -> Void)?
    
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

private extension ErrorView {
    
    func embedViews() {
        [
            imageView,
            titleLabel,
            messageLabel,
            retryButton
        ].forEach {
            addSubview($0)
        }
    }
}

// MARK: - Setup layout

private extension ErrorView {
    
    func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-90)
            make.width.height.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(50)
        }
        
        retryButton.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
            make.width.equalTo(200)
        }
    }
}

// MARK: - Setup appearance

private extension ErrorView {
    
    func setupAppearance() {
        imageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemRed
        
        titleLabel.text = "No Ships Available"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .label
        
        messageLabel.text = "We encountered an unexpected error. Please try again."
        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.textAlignment = .center
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        
        retryButton.setTitle("Retry", for: .normal)
        retryButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        retryButton.setTitleColor(.white, for: .normal)
        retryButton.backgroundColor = .systemRed
        retryButton.layer.cornerRadius = 22
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
    }
}

// MARK: - Actions

private extension ErrorView {
    @objc
    func retryButtonTapped() {
        onRetry?()
    }
}

// MARK: - Public Methods

extension ErrorView {
    func setErrorMessage(_ message: String) {
        messageLabel.text = message
    }
}
