@testable import Differific
import XCTest

class IndexPathManagerTests: XCTestCase {
  let manager = DiffManager()
  let indexPathManager = IndexPathManager()

  func testIndexPathManager() {
    let old = ["Eirik", "Markus", "Andreas"]
    let new = ["Eirik P", "Eirik N", "Markus", "Chris"]
    let changes = manager.diff(old, new)
    let result = indexPathManager.process(changes)

    XCTAssertEqual(result.insert, [
      IndexPath(item: 0, section: 0),
      IndexPath(item: 1, section: 0),
      IndexPath(item: 3, section: 0)
    ])

    XCTAssertTrue(result.updates.isEmpty)

    XCTAssertEqual(result.deletions, [
      IndexPath(item: 0, section: 0),
      IndexPath(item: 2, section: 0)
      ])

    XCTAssertEqual(result.moves.count, 1)
    XCTAssertEqual(result.moves[0].from, IndexPath(item: 1, section: 0))
    XCTAssertEqual(result.moves[0].to, IndexPath(item: 2, section: 0))
  }

  func testIndexPathGeneratingMoves() {
    let old = ["Foo", "Bar", "Baz"]
    let new = ["Baz", "Bar", "Foo"]
    let changes = manager.diff(old, new)
    let result = indexPathManager.process(changes)

    XCTAssertTrue(result.insert.isEmpty)
    XCTAssertTrue(result.updates.isEmpty)
    XCTAssertTrue(result.deletions.isEmpty)

    XCTAssertEqual(result.moves[0].from, IndexPath(item: 2, section: 0))
    XCTAssertEqual(result.moves[0].to, IndexPath(item: 0, section: 0))

    XCTAssertEqual(result.moves[1].from, IndexPath(item: 0, section: 0))
    XCTAssertEqual(result.moves[1].to, IndexPath(item: 2, section: 0))
  }
}
