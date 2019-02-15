import XCTest
import Differific

class DiffManagerTests: XCTestCase {
  struct MockObject: Hashable {
    let id: Int
    let name: String
    var hashValue: Int { return id.hashValue }
  }

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
    let old = [
      MockObject(id: 0, name: "Foo"),
      MockObject(id: 1, name: "Bar"),
      MockObject(id: 2, name: "Baz")
    ]
    let new = [
      MockObject(id: 0, name: "Foo0"),
      MockObject(id: 1, name: "Bar1"),
      MockObject(id: 2, name: "Baz2")
    ]
    let result = manager.diff(old, new)

    XCTAssertEqual(result.count, 3)

    XCTAssertEqual(result[0].kind, .update)
    XCTAssertEqual(result[0].item, MockObject(id: 0, name: "Foo"))
    XCTAssertEqual(result[0].newItem, MockObject(id: 0, name: "Foo0"))
    XCTAssertEqual(result[0].index, 0)

    XCTAssertEqual(result[1].kind, .update)
    XCTAssertEqual(result[1].item, MockObject(id: 1, name: "Bar"))
    XCTAssertEqual(result[1].newItem, MockObject(id: 1, name: "Bar1"))
    XCTAssertEqual(result[1].index, 1)

    XCTAssertEqual(result[2].kind, .update)
    XCTAssertEqual(result[2].item, MockObject(id: 2, name: "Baz"))
    XCTAssertEqual(result[2].newItem, MockObject(id: 2, name: "Baz2"))
    XCTAssertEqual(result[2].index, 2)

  }

  func testDiffing() {
    let old = [
      MockObject(id: 0, name: "Eirik"),
      MockObject(id: 1, name: "Markus"),
      MockObject(id: 2, name: "Andreas")
    ]
    let new = [
      MockObject(id: 3, name: "Eirik P"),
      MockObject(id: 0, name: "Eirik N"),
      MockObject(id: 1, name: "Markus"),
      MockObject(id: 4, name: "Chris")
    ]
    let result = manager.diff(old, new)

    XCTAssertEqual(result[0].kind, .delete)
    XCTAssertEqual(result[0].item, MockObject(id: 2, name: "Andreas"))

    XCTAssertEqual(result[1].kind, .insert)
    XCTAssertEqual(result[1].item, MockObject(id: 3, name: "Eirik P"))

    XCTAssertEqual(result[2].kind, .update)
    XCTAssertEqual(result[2].item, MockObject(id: 0, name: "Eirik"))

    XCTAssertEqual(result[3].kind, .move)
    XCTAssertEqual(result[3].item, MockObject(id: 1, name: "Markus"))

    XCTAssertEqual(result[4].kind, .insert)
    XCTAssertEqual(result[4].item, MockObject(id: 4, name: "Chris"))

    XCTAssertEqual(result.count, 5)
  }

  func testPerformance() {
    let diffManager = DiffManager()
    var old = [Int]()
    var new = [Int]()
    let amount = 1_000_000

    new.reserveCapacity(amount)
    old.reserveCapacity(amount)

    for x in 0..<amount {
      old.append(x)
      new.append(x)
    }

    let startTime = CACurrentMediaTime()

    _ = diffManager.diff(old, new.reversed())

    NSLog("🏎 Total Runtime: \(CACurrentMediaTime() - startTime)")
  }
}
