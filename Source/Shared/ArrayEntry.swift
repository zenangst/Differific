import Foundation

struct ArrayEntry: Equatable {
  let tableEntry: TableEntry
  var indexInOther: Int

  init(tableEntry: TableEntry, indexInOther: Int = -1) {
    self.tableEntry = tableEntry
    self.indexInOther = indexInOther
  }
}
