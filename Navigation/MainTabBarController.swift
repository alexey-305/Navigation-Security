import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
        setupMoreTabTitle()
    }
    
    private func setupMoreTabTitle() {
        moreNavigationController.tabBarItem.title = "tabbar.more".localized
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttributes
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemBlue
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttributes
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.isTranslucent = false
    }
    
    private func setupTabs() {
        let randomVC = RandomQuoteViewController()
        randomVC.tabBarItem = UITabBarItem(
            title: "tabbar.random".localized,
            image: UIImage(systemName: "quote.bubble"),
            tag: 0
        )
        let nav1 = UINavigationController(rootViewController: randomVC)
        
        let allVC = AllQuotesViewController()
        allVC.tabBarItem = UITabBarItem(
            title: "tabbar.all_quotes".localized,
            image: UIImage(systemName: "list.bullet"),
            tag: 1
        )
        let nav2 = UINavigationController(rootViewController: allVC)
        
        let categoriesVC = CategoriesViewController()
        categoriesVC.tabBarItem = UITabBarItem(
            title: "tabbar.categories".localized,
            image: UIImage(systemName: "folder"),
            tag: 2
        )
        let nav3 = UINavigationController(rootViewController: categoriesVC)
        
        let feedVC = FeedViewController()
        feedVC.tabBarItem = UITabBarItem(
            title: "tabbar.feed".localized,
            image: UIImage(systemName: "newspaper"),
            tag: 3
        )
        let nav4 = UINavigationController(rootViewController: feedVC)
        
        let favoritesVC = FavoritesViewController()
        favoritesVC.tabBarItem = UITabBarItem(
            title: "tabbar.favorites".localized,
            image: UIImage(systemName: "heart"),
            tag: 4
        )
        let nav5 = UINavigationController(rootViewController: favoritesVC)
        
        let mapVC = MapViewController()
        mapVC.tabBarItem = UITabBarItem(
            title: "tabbar.map".localized,
            image: UIImage(systemName: "map"),
            tag: 5
        )
        let nav6 = UINavigationController(rootViewController: mapVC)
        
        viewControllers = [nav1, nav2, nav3, nav6, nav5, nav4]
    }
}
