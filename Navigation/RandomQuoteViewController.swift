import UIKit

class RandomQuoteViewController: UIViewController {
    
    private let viewModel = RandomQuoteViewModel()
    
    private let quoteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = AppFonts.body
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "random_quote.hint".localized
        return label
    }()
    
    private let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("random_quote.button.load".localized, for: .normal)
        button.backgroundColor = AppColors.accent
        button.setTitleColor(AppColors.onAccentText, for: .normal)
        button.titleLabel?.font = AppFonts.button
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        title = "random_quote.title".localized
        setupUI()
        bindViewModel()
        loadButton.addTarget(self, action: #selector(loadQuote), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.addSubview(quoteLabel)
        view.addSubview(loadButton)
        
        NSLayoutConstraint.activate([
            quoteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quoteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            quoteLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            quoteLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadButton.topAnchor.constraint(equalTo: quoteLabel.bottomAnchor, constant: 30),
            loadButton.widthAnchor.constraint(equalToConstant: 200),
            loadButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func bindViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            self?.handle(state: state)
        }
    }
    
    private func handle(state: RandomQuoteViewState) {
        switch state {
        case .idle:
            break
        case .loading:
            loadButton.isEnabled = false
            loadButton.setTitle("random_quote.button.loading".localized, for: .normal)
        case .loaded(let text):
            loadButton.isEnabled = true
            loadButton.setTitle("random_quote.button.load".localized, for: .normal)
            quoteLabel.text = text
        case .failed(let message):
            loadButton.isEnabled = true
            loadButton.setTitle("random_quote.button.load".localized, for: .normal)
            quoteLabel.text = message
        }
    }
    
    @objc private func loadQuote() {
        viewModel.loadRandomQuote()
    }
}
