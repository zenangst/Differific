import XCTest
import Differific

class UITableViewExtensionsTests: XCTestCase {
  class DataSourceMock: NSObject, UITableViewDataSource {
    var models = [String]()

    init(models: [String] = []) {
      self.models = models
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return models.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      return cell
    }
  }

  func testReloadWithInsertions() {
    let dataSource = DataSourceMock()
    let tableView = UITableView()
    tableView.dataSource = dataSource
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")

    let old = dataSource.models
    let new = ["Foo", "Bar", "Baz"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    tableView.reload(with: changes, updateDataSource: {
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
    let tableView = UITableView()
    tableView.dataSource = dataSource
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")

    let old = dataSource.models
    let new = ["Baz", "Bar", "Foo"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    tableView.reload(with: changes, updateDataSource: {
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
    let tableView = UITableView()
    tableView.dataSource = dataSource
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")

    let old = dataSource.models
    let new = [String]()
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    tableView.reload(with: changes, updateDataSource: {
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
    let tableView = UITableView()
    tableView.dataSource = dataSource
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "cell")

    let old = dataSource.models
    let new = ["Foo", "Bar", "Baz"]
    let manager = DiffManager()
    let changes = manager.diff(old, new)

    var ranBefore: Bool = false
    var ranCompletion: Bool = false

    tableView.reload(with: changes, updateDataSource: {
      dataSource.models = new
      ranBefore = true
    }) {
      ranCompletion = true
    }

    XCTAssertFalse(ranBefore)
    XCTAssertTrue(ranCompletion)
  }
}
