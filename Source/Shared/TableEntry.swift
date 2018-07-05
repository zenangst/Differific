import Foundation

class TableEntry: Equatable {
  var oldCounter: Counter = .zero
  var newCounter: Counter = .zero
  var indexesInOld: [Int] = []
  var appearsInBoth: Bool {
    return oldCounter != .zero && newCounter != .zero
  }

  static func == (lhs: TableEntry, rhs: TableEntry) -> Bool {
    return lhs.oldCounter == rhs.oldCounter &&
      lhs.newCounter == rhs.newCounter &&
      lhs.indexesInOld == rhs.indexesInOld
  }
}
