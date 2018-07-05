import Foundation

class Algorithm {
  public static func diff<T: Hashable>(old: [T], new: [T]) -> [Change<T>] {
    if new.isEmpty {
      var changes = [Change<T>]()
      for (offset, element) in old.enumerated() {
        changes.append(Change(.delete,
                              item: element,
                              index: offset))
      }
      return changes
    }

    var table = [Int: TableEntry]()
    var (oldArray, newArray) = ([ArrayEntry](), [ArrayEntry]())
    var deleteOffsets = Array(repeating: 0, count: old.count)
    var changes = [Change<T>]()
    var (runningDeleteOffset, runningOffset, offset) = (0, 0, 0)

    // 1 Pass
    for element in new[0...].lazy {
      defer { offset += 1 }

      let entry: TableEntry
      if let tableEntry = table[element.hashValue] {
        entry = tableEntry
      } else {
        entry = TableEntry()
      }

      table[element.hashValue] = entry
      entry.newCounter = entry.newCounter.increment()
      newArray.append(.tableEntry(entry))
    }

    // 2 Pass
    offset = 0
    for element in old[0...].lazy {
      defer { offset += 1 }

      let entry: TableEntry
      if let tableEntry = table[element.hashValue] {
        entry = tableEntry
      } else {
        entry = TableEntry()
      }

      table[element.hashValue] = entry
      entry.oldCounter = entry.oldCounter.increment()
      entry.indexesInOld.append(offset)
      oldArray.append(.tableEntry(entry))
    }

    // 3rd Pass
    offset = 0
    for element in newArray[0...].lazy {
      defer { offset += 1 }
      if case let .tableEntry(entry) = element, (entry.appearsInBoth && !entry.indexesInOld.isEmpty) {
        let oldIndex = entry.indexesInOld.removeFirst()
        newArray[offset] = .indexInOther(oldIndex)
        oldArray[oldIndex] = .indexInOther(offset)
      }
    }

    // 4th Pass
    offset = 1
    repeat {
      if case let .indexInOther(otherIndex) = newArray[offset], otherIndex + 1 < oldArray.count,
        case let .tableEntry(newEntry) = newArray[offset + 1],
        case let .tableEntry(oldEntry) = oldArray[otherIndex + 1], newEntry === oldEntry {
        newArray[offset + 1] = .indexInOther(otherIndex + 1)
        oldArray[otherIndex + 1] = .indexInOther(offset + 1)
      }
      offset += 1
    } while offset < newArray.count - 1

    // 5th Pass
    offset = newArray.count - 1
    repeat {
      if case let .indexInOther(otherIndex) = newArray[offset], otherIndex - 1 >= 0,
        case let .tableEntry(newEntry) = newArray[offset - 1],
        case let .tableEntry(oldEntry) = oldArray[otherIndex - 1], newEntry === oldEntry {
        newArray[offset + 1] = .indexInOther(otherIndex + 1)
        oldArray[otherIndex + 1] = .indexInOther(offset + 1)
      }
      offset -= 1
    } while offset > 0

    // Handle deleted objects
    offset = 0
    for element in oldArray[0...].lazy {
      defer { offset += 1 }
      deleteOffsets[offset] = runningOffset
      if case let .tableEntry(entry) = element {
        changes.append(Change(.delete,
                              item: old[offset],
                              index: offset))
        runningOffset += 1
      }
    }

    // Handle insert, updates and move.
    offset = 0
    for element in newArray[0...].lazy {
      defer { offset += 1 }
      switch element {
      case .tableEntry(_):
        changes.append(Change(.insert,
                              item: new[offset],
                              index: offset))
        runningOffset += 1
      case .indexInOther(let oldIndex):
        if old[oldIndex] != new[offset] {
          changes.append(Change(.update,
                                item: old[oldIndex],
                                index: oldIndex,
                                newIndex: offset,
                                newItem: new[offset]))
        } else {
          let deleteOffset = deleteOffsets[oldIndex]
          if (oldIndex - deleteOffset + runningOffset) != offset {
            changes.append(Change(.move,
                                  item: new[offset],
                                  index: oldIndex,
                                  newIndex: offset))
          }
        }
      }
    }

    return changes
  }
}
