import Foundation

enum FeedViewState: Equatable {
    case idle
    case loaded
    case alreadyInFavorites
    case addedToFavorites
}

/// Абстракция над CoreDataManager, чтобы во ViewModel не было прямой зависимости
/// от CoreData и её можно было подменить на фейк в unit-тестах
protocol FavoritesStoring {
    func isPostAlreadySaved(id: String) -> Bool
    func savePost(id: String, title: String, text: String, author: String, likes: Int, imageName: String?)
}

extension CoreDataManager: FavoritesStoring {}

final class FeedViewModel {
    
    private(set) var posts: [Post] = []
    
    private(set) var state: FeedViewState = .idle {
        didSet { onStateChanged?(state) }
    }
    
    var onStateChanged: ((FeedViewState) -> Void)?
    
    private let favoritesStore: FavoritesStoring
    
    init(favoritesStore: FavoritesStoring = CoreDataManager.shared) {
        self.favoritesStore = favoritesStore
    }
    
    func loadPosts() {
        posts = [
            Post(author: "Алексей", description: "Первый пост в ленте! Сегодня отличная погода ☀️", image: "img1", likes: 5, views: 100),
            Post(author: "Мария", description: "Изучаю Swift и создаю крутые приложения 🚀", image: "img2", likes: 12, views: 250),
            Post(author: "Иван", description: "CoreData — мощный инструмент для хранения данных", image: "img3", likes: 8, views: 180),
            Post(author: "Елена", description: "Realm vs CoreData: что выбрать для проекта? 🤔", image: "img4", likes: 15, views: 320)
        ]
        state = .loaded
    }
    
    /// Пытается сохранить пост по индексу в избранное.
    /// Если пост уже сохранён — переводит state в .alreadyInFavorites, иначе сохраняет и переводит в .addedToFavorites
    func addToFavorites(at index: Int) {
        guard posts.indices.contains(index) else { return }
        let post = posts[index]
        
        if favoritesStore.isPostAlreadySaved(id: post.id) {
            state = .alreadyInFavorites
            return
        }
        
        favoritesStore.savePost(
            id: post.id,
            title: post.description,
            text: post.description,
            author: post.author,
            likes: post.likes,
            imageName: post.image
        )
        state = .addedToFavorites
    }
}
