import UIKit

class RandomQuoteViewController: UIViewController {
    
    private let apiService = APIService()
    private let realmService = RealmService.shared
    
    private let quoteLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "random_quote.hint".localized
        return label
    }()
    
    private let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("random_quote.button.load".localized, for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        title = "random_quote.title".localized
        setupUI()
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
    
    @objc private func loadQuote() {
        loadButton.isEnabled = false
        loadButton.setTitle("random_quote.button.loading".localized, for: .normal)
        
        apiService.fetchRandomQuote { [weak self] result in
            DispatchQueue.main.async {
                self?.loadButton.isEnabled = true
                self?.loadButton.setTitle("random_quote.button.load".localized, for: .normal)
                
                switch result {
                case .success(let quote):
                    self?.quoteLabel.text = quote.value
                    self?.realmService.saveQuote(text: quote.value, category: quote.category ?? "random_quote.category.none".localized)
                case .failure(let error):
                    self?.quoteLabel.text = "random_quote.error.format".localized(error.localizedDescription)
                }
            }
        }
    }
}
