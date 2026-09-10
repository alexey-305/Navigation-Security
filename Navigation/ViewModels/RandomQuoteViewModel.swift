import Foundation

enum RandomQuoteViewState: Equatable {
    case idle
    case loading
    case loaded(text: String)
    case failed(String)
}

final class RandomQuoteViewModel {
    
    private(set) var state: RandomQuoteViewState = .idle {
        didSet { onStateChanged?(state) }
    }
    
    var onStateChanged: ((RandomQuoteViewState) -> Void)?
    
    private let apiService: APIService
    private let realmService: RealmService
    
    init(apiService: APIService = APIService(), realmService: RealmService = .shared) {
        self.apiService = apiService
        self.realmService = realmService
    }
    
    func loadRandomQuote() {
        state = .loading
        
        apiService.fetchRandomQuote { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let quote):
                    self.realmService.saveQuote(
                        text: quote.value,
                        category: quote.category ?? "random_quote.category.none".localized
                    )
                    self.state = .loaded(text: quote.value)
                case .failure(let error):
                    self.state = .failed("random_quote.error.format".localized(error.localizedDescription))
                }
            }
        }
    }
}
