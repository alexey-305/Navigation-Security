import UIKit

struct Post {
    let id: String
    let author: String
    let description: String
    let image: UIImage
    let likes: Int
    let views: Int
    /// Имя ассета, если пост создан из Assets.xcassets — нужно только для сохранения
    /// в CoreData (избранное), где картинка хранится как имя, а не как сами данные.
    /// Для постов, созданных через drag&drop, будет nil.
    let imageAssetName: String?
    
    init(author: String, description: String, image: UIImage, likes: Int, views: Int, imageAssetName: String? = nil) {
        self.id = UUID().uuidString   // стабильный уникальный идентификатор
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
        self.imageAssetName = imageAssetName
    }
}
