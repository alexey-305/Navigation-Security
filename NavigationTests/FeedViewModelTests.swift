import XCTest
@testable import Navigation

final class FavoritesStoringMock: FavoritesStoring {
    var isAlreadySaved = false
    private(set) var savedPostIDs: [String] = []
    
    func isPostAlreadySaved(id: String) -> Bool {
        return isAlreadySaved
    }
    
    func savePost(id: String, title: String, text: String, author: String, likes: Int, imageName: String?) {
        savedPostIDs.append(id)
    }
}

final class FeedViewModelTests: XCTestCase {
    
    private var favoritesStoreMock: FavoritesStoringMock!
    private var sut: FeedViewModel!
    
    override func setUp() {
        super.setUp()
        favoritesStoreMock = FavoritesStoringMock()
        sut = FeedViewModel(favoritesStore: favoritesStoreMock)
    }
    
    override func tearDown() {
        favoritesStoreMock = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - loadPosts()
    
    func test_loadPosts_populatesPostsAndSetsLoadedState() {
        // given
        var receivedState: FeedViewState?
        sut.onStateChanged = { receivedState = $0 }
        
        // when
        sut.loadPosts()
        
        // then
        XCTAssertFalse(sut.posts.isEmpty)
        XCTAssertEqual(receivedState, .loaded)
    }
    
    // MARK: - addToFavorites(at:)
    
    func test_addToFavorites_newPost_savesItAndSetsAddedState() {
        // given
        sut.loadPosts()
        favoritesStoreMock.isAlreadySaved = false
        var receivedState: FeedViewState?
        sut.onStateChanged = { receivedState = $0 }
        
        // when
        sut.addToFavorites(at: 0)
        
        // then
        XCTAssertEqual(favoritesStoreMock.savedPostIDs.count, 1)
        XCTAssertEqual(receivedState, .addedToFavorites)
    }
    
    func test_addToFavorites_postAlreadySaved_doesNotSaveAgainAndSetsAlreadyInFavoritesState() {
        // given
        sut.loadPosts()
        favoritesStoreMock.isAlreadySaved = true
        var receivedState: FeedViewState?
        sut.onStateChanged = { receivedState = $0 }
        
        // when
        sut.addToFavorites(at: 0)
        
        // then
        XCTAssertTrue(favoritesStoreMock.savedPostIDs.isEmpty)
        XCTAssertEqual(receivedState, .alreadyInFavorites)
    }
    
    func test_addToFavorites_invalidIndex_doesNothingAndDoesNotChangeState() {
        // given
        sut.loadPosts()
        var receivedState: FeedViewState?
        sut.onStateChanged = { receivedState = $0 }
        
        // when
        sut.addToFavorites(at: 999)
        
        // then
        XCTAssertTrue(favoritesStoreMock.savedPostIDs.isEmpty)
        XCTAssertNil(receivedState)
    }
}
