import XCTest
import Differific

class DiffManagerTests: XCTestCase {
  let manager = DiffManager()

  func testEmptyDiff() {
    let old = [String]()
    let new = [String]()
    let result = manager.diff(old, new)

    XCTAssertTrue(result.isEmpty)
  }

  func testInsert() {
    let old = [String]()
    let new = ["Foo", "Bar", "Baz"]
    let result = manager.diff(old, new)

    XCTAssertEqual(result.count, 3)

    XCTAssertEqual(result[0].kind, .insert)
    XCTAssertEqual(result[0].item, "Foo")
    XCTAssertEqual(result[0].index, 0)

    XCTAssertEqual(result[1].kind, .insert)
    XCTAssertEqual(result[1].item, "Bar")
    XCTAssertEqual(result[1].index, 1)

    XCTAssertEqual(result[2].kind, .insert)
    XCTAssertEqual(result[2].item, "Baz")
    XCTAssertEqual(result[2].index, 2)
  }

  func testDelete() {
    let old = ["Foo", "Bar", "Baz"]
    let new = [String]()
    let result = manager.diff(old, new)

    XCTAssertEqual(result.count, 3)

    XCTAssertEqual(result[0].kind, .delete)
    XCTAssertEqual(result[0].item, "Foo")
    XCTAssertEqual(result[0].index, 0)

    XCTAssertEqual(result[1].kind, .delete)
    XCTAssertEqual(result[1].item, "Bar")
    XCTAssertEqual(result[1].index, 1)

    XCTAssertEqual(result[2].kind, .delete)
    XCTAssertEqual(result[2].item, "Baz")
    XCTAssertEqual(result[2].index, 2)
  }

  func testMove() {
    let old = ["Foo", "Bar", "Baz"]
    let new = Array(old.reversed())
    let result = manager.diff(old, new)

    XCTAssertEqual(result.count, 2)

    XCTAssertEqual(result[0].kind, .move)
    XCTAssertEqual(result[0].item, "Baz")
    XCTAssertEqual(result[0].index, 2)
    XCTAssertEqual(result[0].newIndex, 0)

    XCTAssertEqual(result[1].kind, .move)
    XCTAssertEqual(result[1].item, "Foo")
    XCTAssertEqual(result[1].index, 0)
    XCTAssertEqual(result[1].newIndex, 2)
  }

  func testNoChange() {
    let old = ["Foo", "Bar", "Baz"]
    let new = ["Foo", "Bar", "Baz"]
    let result = manager.diff(old, new)

    XCTAssertTrue(result.isEmpty)
  }

  func testReplacing() {
    let old = ["Foo", "Bar", "Baz"]
    let new = old.compactMap { $0.uppercased() }
    let result = manager.diff(old, new)

    XCTAssertEqual(result.count, 6)

    XCTAssertEqual(result[0].kind, .delete)
    XCTAssertEqual(result[0].item, "Foo")
    XCTAssertEqual(result[0].index, 0)

    XCTAssertEqual(result[1].kind, .delete)
    XCTAssertEqual(result[1].item, "Bar")
    XCTAssertEqual(result[1].index, 1)

    XCTAssertEqual(result[2].kind, .delete)
    XCTAssertEqual(result[2].item, "Baz")
    XCTAssertEqual(result[2].index, 2)

    XCTAssertEqual(result[3].kind, .insert)
    XCTAssertEqual(result[3].item, "FOO")
    XCTAssertEqual(result[3].index, 0)

    XCTAssertEqual(result[4].kind, .insert)
    XCTAssertEqual(result[4].item, "BAR")
    XCTAssertEqual(result[4].index, 1)

    XCTAssertEqual(result[5].kind, .insert)
    XCTAssertEqual(result[5].item, "BAZ")
    XCTAssertEqual(result[5].index, 2)

  }

  func testDiffing() {
    let old = ["Eirik", "Markus", "Andreas"]
    let new = ["Eirik P", "Eirik N", "Markus", "Chris"]
    let result = manager.diff(old, new)

    XCTAssertEqual(result.count, 5)
  }
}
