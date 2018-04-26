import XCTest
import Differific

class NSTableViewExtensionsTests: XCTestCase {
  class DataSourceMock: NSObject, NSTableViewDataSource {
    var models = [String]()

    init(models: [String] = []) {
      self.models = models
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
      return models.count
    }
  }

  func testReloadWithInsertions() {
    let dataSource = DataSourceMock()
    let tableView = NSTableView()
    tableView.dataSource = dataSource

    let old = dataSource.models
    let new = ["Foo", "Bar", "Baz"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    tableView.reload(with: changes, animation: .effectFade, before: { _ in
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
    let tableView = NSTableView()
    tableView.dataSource = dataSource

    let old = dataSource.models
    let new = ["Baz", "Bar", "Foo"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    tableView.reload(with: changes, animation: .effectFade, before: { _ in
      dataSource.models = new
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertTrue(ranBefore)
    XCTAssertTrue(ranCompletion)
  }

  func testReloadWithDeletions() {
    let dataSource = DataSourceMock(models: ["Foo", "Bar", "Baz"])
    let tableView = NSTableView()
    tableView.dataSource = dataSource

    let old = dataSource.models
    let new = [String]()
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    tableView.reload(with: changes, animation: .effectFade, before: { _ in
      dataSource.models = new
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertTrue(ranBefore)
    XCTAssertTrue(ranCompletion)
  }

  func testReloadWithEmptyChanges() {
    let dataSource = DataSourceMock(models: ["Foo", "Bar", "Baz"])
    let tableView = NSTableView()
    tableView.dataSource = dataSource

    let old = dataSource.models
    let new = ["Foo", "Bar", "Baz"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    tableView.reload(with: changes, animation: .effectFade, before: { _ in
      dataSource.models = new
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertFalse(ranBefore)
    XCTAssertTrue(ranCompletion)
  }
}
