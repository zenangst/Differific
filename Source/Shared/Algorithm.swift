import Foundation

class Algorithm {
  public static func diff<T: Hashable>(old: [T], new: [T]) -> [Change<T>] {
    var table: [Int: TableEntry] = [:]
    var (oldArray, newArray) = ([ArrayEntry](), [ArrayEntry]())
    var changes = [Change<T>]()
    var deleteOffsets = Array(repeating: 0, count: old.count)
    var runningDeleteOffset = 0
    var runningOffset = 0
    var offset = 0

    for element in old[0...] {
      defer { offset += 1 }
      let entry = table[element.hashValue] ?? TableEntry()
      entry.oldCounter = entry.oldCounter.increment()
      entry.indexesInOld.append(offset)
      let oldArrayEntry: ArrayEntry = .tableEntry(entry)
      oldArray.append(oldArrayEntry)
      table[element.hashValue] = entry
    }

    offset = 0
    for element in new[0...] {
      defer { offset += 1 }
      let entry = table[element.hashValue] ?? TableEntry()
      let arrayEntry: ArrayEntry = .tableEntry(entry)
      entry.newCounter = entry.newCounter.increment()
      newArray.append(arrayEntry)
      table[element.hashValue] = entry

      switch arrayEntry {
      case .tableEntry(let entry):
        guard !entry.indexesInOld.isEmpty else { continue }
        let indexOfOld = entry.indexesInOld.removeFirst()
        let isObservation1 = entry.newCounter == .one &&
          entry.oldCounter == .one
        let isObservation2 = entry.newCounter != .zero &&
          entry.oldCounter != .zero && newArray[offset] == oldArray[indexOfOld]
        if isObservation1 || isObservation2 {
          newArray[offset] = .indexInOther(indexOfOld)
          oldArray[indexOfOld] = .indexInOther(offset)
        }
      case .indexInOther:
        continue
      }
    }

    // Handle deletions
    offset = 0
    for element in oldArray[0...] {
      defer { offset += 1 }

      deleteOffsets[offset] = runningDeleteOffset
      guard case .tableEntry = element else { continue }

      changes.append(Change(.delete,
                            item: old[offset],
                            index: offset))
      runningDeleteOffset += 1
    }

    // Handle insert, updates and move.

    offset = 0
    for element in newArray[0...] {
      defer { offset += 1 }
      switch element {
      case .tableEntry:
        runningOffset += 1
        changes.append(Change(.insert,
                              item: new[offset],
                              index: offset))
      case .indexInOther(let oldIndex):
        if old[oldIndex] != new[offset] {
          changes.append(Change(.replace,
                                item: old[oldIndex],
                                index: oldIndex,
                                newIndex: offset,
                                newItem: new[offset]))
        }

        let deleteOffset = deleteOffsets[oldIndex]
        if (oldIndex - deleteOffset + runningOffset) != offset {
          changes.append(Change(.move,
                                item: new[offset],
                                index: oldIndex,
                                newIndex: offset))
        }
      }
    }

    return changes
  }
}
