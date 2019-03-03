import Foundation

class TableEntry: Equatable {
  var oldCounter: Int = 0
  var newCounter: Int = 0
  var indexesInOld: [Int] = []
  var appearsInBoth: Bool {
    return oldCounter > 0 && newCounter > 0
  }

  static func == (lhs: TableEntry, rhs: TableEntry) -> Bool {
    return lhs.oldCounter == rhs.oldCounter &&
      lhs.newCounter == rhs.newCounter &&
      lhs.indexesInOld == rhs.indexesInOld
  }
}
