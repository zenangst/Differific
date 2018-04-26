import XCTest
import Differific

class NSCollectionViewExtensionsTests: XCTestCase {
  class DataSourceMock: NSObject, NSCollectionViewDataSource {
    var models: [String]

    init(models: [String] = []) {
      self.models = models
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
      return models.count
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
      let cell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier.init("cell"), for: indexPath)
      return cell
    }
  }

  func testReloadWithInsertions() {
    let dataSource = DataSourceMock(models: [])
    let layout = NSCollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 250, height: 250)

    let collectionView = NSCollectionView(frame: .init(origin: .zero, size: layout.itemSize))
    collectionView.collectionViewLayout = layout
    collectionView.dataSource = dataSource
    collectionView.register(NSCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init("cell"))

    let old = dataSource.models
    let new = ["Foo", "Bar", "Baz"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)
    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    dataSource.models = new
    collectionView.reload(with: changes, before: { _ in
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertTrue(ranBefore)
    XCTAssertTrue(ranCompletion)
  }

  func testReloadWithMove() {
    let dataSource = DataSourceMock(models: ["Foo", "Bar", "Baz"])
    let layout = NSCollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 250, height: 250)
    let collectionView = NSCollectionView(frame: .init(origin: .zero, size: layout.itemSize))
    collectionView.collectionViewLayout = layout
    collectionView.dataSource = dataSource
    collectionView.register(NSCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init("cell"))

    let old = dataSource.models
    let new = ["Baz", "Bar", "Foo"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    dataSource.models = new
    collectionView.reload(with: changes, before: { _ in
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertTrue(ranBefore)
    XCTAssertTrue(ranCompletion)
  }

  func testReloadWithDeletions() {
    let dataSource = DataSourceMock(models: ["Foo", "Bar", "Baz"])
    let layout = NSCollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 250, height: 250)
    let collectionView = NSCollectionView(frame: .init(origin: .zero, size: layout.itemSize))
    collectionView.collectionViewLayout = layout
    collectionView.dataSource = dataSource
    collectionView.register(NSCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init("cell"))

    let old = dataSource.models
    let new = [String]()
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    dataSource.models = new
    collectionView.reload(with: changes, before: { _ in
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertTrue(ranBefore)
    XCTAssertTrue(ranCompletion)
  }

  func testReloadWithEmptyChanges() {
    let dataSource = DataSourceMock(models: ["Foo", "Bar", "Baz"])
    let layout = NSCollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 250, height: 250)
    let collectionView = NSCollectionView(frame: .init(origin: .zero, size: layout.itemSize))
    collectionView.collectionViewLayout = layout
    collectionView.dataSource = dataSource
    collectionView.register(NSCollectionViewItem.self, forItemWithIdentifier: NSUserInterfaceItemIdentifier.init("cell"))

    let old = dataSource.models
    let new = ["Foo", "Bar", "Baz"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    dataSource.models = new
    collectionView.reload(with: changes, before: { _ in
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertFalse(ranBefore)
    XCTAssertTrue(ranCompletion)
  }
}
