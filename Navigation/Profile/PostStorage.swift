import UIKit

/// Глобальное хранилище постов профиля.
/// Задача 1: сюда добавляются новые посты, созданные через drag&drop.
final class PostStorage {
    
    static let shared = PostStorage()
    
    private init() {
        posts = [
            Post(
                author: "cat_lover_2024",
                description: "Сегодня мой кот поймал солнечного зайчика! 🐱☀️",
                image: UIImage(named: "1") ?? UIImage(),
                likes: 120,
                views: 456,
                imageAssetName: "1"
            ),
            Post(
                author: "hipster_cat",
                description: "Новый диван - новое место для сна.",
                image: UIImage(named: "2") ?? UIImage(),
                likes: 89,
                views: 234,
                imageAssetName: "2"
            ),
            Post(
                author: "crazy_cat_lady",
                description: "Купила новую игрушку, а кот играет с коробкой.",
                image: UIImage(named: "3") ?? UIImage(),
                likes: 256,
                views: 789,
                imageAssetName: "3"
            ),
            Post(
                author: "philosopher_cat",
                description: "Зачем люди ходят на работу?",
                image: UIImage(named: "4") ?? UIImage(),
                likes: 445,
                views: 1234,
                imageAssetName: "4"
            )
        ]
    }
    
    private(set) var posts: [Post]
    
    /// Добавляет новый пост в начало списка (Задача 1, пункт 6)
    func add(_ post: Post) {
        posts.insert(post, at: 0)
    }
}
