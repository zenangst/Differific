import Foundation

enum ArrayEntry: Equatable {
  case tableEntry(TableEntry)
  case indexInOther(Int)

  public static func == (lhs: ArrayEntry, rhs: ArrayEntry) -> Bool {
    switch (lhs, rhs) {
    case (.tableEntry(let l), .tableEntry(let r)):
      return l == r
    case (.indexInOther(let l), .indexInOther(let r)):
      return l == r
    default:
      return false
    }
  }
}
