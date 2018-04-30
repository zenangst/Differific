import XCTest
import Differific

class UICollectionViewExtensionsTests: XCTestCase {
  class DataSourceMock: NSObject, UICollectionViewDataSource {
    var models: [String]

    init(models: [String] = []) {
      self.models = models
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      return cell
    }
  }

  func testReloadWithInsertions() {
    let dataSource = DataSourceMock(models: [])
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 250, height: 250)
    let collectionView = UICollectionView(frame: .init(origin: .zero, size: layout.itemSize),
                                          collectionViewLayout: layout)
    collectionView.dataSource = dataSource
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

    let old = dataSource.models
    let new = ["Foo", "Bar", "Baz"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)
    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    collectionView.reload(with: changes, before: {
      dataSource.models = new
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertTrue(ranBefore)
    XCTAssertTrue(ranCompletion)
  }

  func testReloadWithMove() {
    let dataSource = DataSourceMock(models: ["Foo", "Bar", "Baz"])
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 250, height: 250)
    let collectionView = UICollectionView(frame: .init(origin: .zero, size: layout.itemSize),
                                          collectionViewLayout: layout)
    collectionView.dataSource = dataSource
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

    let old = dataSource.models
    let new = ["Baz", "Bar", "Foo"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    dataSource.models = new
    collectionView.reload(with: changes, before: {
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertTrue(ranBefore)
    XCTAssertTrue(ranCompletion)
  }

  func testReloadWithDeletions() {
    let dataSource = DataSourceMock(models: ["Foo", "Bar", "Baz"])
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 250, height: 250)
    let collectionView = UICollectionView(frame: .init(origin: .zero, size: layout.itemSize),
                                          collectionViewLayout: layout)
    collectionView.dataSource = dataSource
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

    let old = dataSource.models
    let new = [String]()
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    dataSource.models = new
    collectionView.reload(with: changes, before: {
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertTrue(ranBefore)
    XCTAssertTrue(ranCompletion)
  }

  func testReloadWithEmptyChanges() {
    let dataSource = DataSourceMock(models: ["Foo", "Bar", "Baz"])
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 250, height: 250)
    let collectionView = UICollectionView(frame: .init(origin: .zero, size: layout.itemSize),
                                          collectionViewLayout: layout)
    collectionView.dataSource = dataSource
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")

    let old = dataSource.models
    let new = ["Foo", "Bar", "Baz"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    dataSource.models = new
    collectionView.reload(with: changes, before: {
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertFalse(ranBefore)
    XCTAssertTrue(ranCompletion)
  }
}
