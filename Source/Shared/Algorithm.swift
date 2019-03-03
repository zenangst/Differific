import Foundation

class Algorithm {
  public static func diff<T: Hashable>(old: [T], new: [T]) -> [Change<T>] {
    if new.isEmpty {
      var changes = [Change<T>]()
      changes.reserveCapacity(old.count)
      for (offset, element) in old.enumerated() {
        changes.append(Change(.delete,
                              item: element,
                              index: offset))
      }
      return changes
    } else if old.isEmpty {
      var changes = [Change<T>]()
      changes.reserveCapacity(new.count)
      for (offset, element) in new.enumerated() {
        changes.append(Change(.insert,
                              item: element,
                              index: offset))
      }
      return changes
    }

    var table = [Int: TableEntry]()
    var (oldArray, newArray) = ([ArrayEntry](), [ArrayEntry]())
    var deleteOffsets = Array(repeating: 0, count: old.count)
    var changes = [Change<T>]()
    var (runningOffset, offset) = (0, 0)

    table.reserveCapacity(new.count > old.count ? new.count : old.count)
    changes.reserveCapacity(newArray.count + oldArray.count)
    newArray.reserveCapacity(new.count)
    oldArray.reserveCapacity(old.count)

    // 1 Pass
    for element in new[0...].lazy {
      let entry: TableEntry
      if let tableEntry = table[element.hashValue] {
        entry = tableEntry
      } else {
        entry = TableEntry()
      }

      table[element.hashValue] = entry
      entry.newCounter += 1
      newArray.append(ArrayEntry(tableEntry: entry))
    }

    // 2 Pass
    for element in old[0...].lazy {
      let entry: TableEntry
      if let tableEntry = table[element.hashValue] {
        entry = tableEntry
      } else {
        entry = TableEntry()
      }

      table[element.hashValue] = entry
      entry.oldCounter += 1
      entry.indexesInOld.append(offset)
      oldArray.append(ArrayEntry(tableEntry: entry))
      offset += 1
    }

    // 3rd Pass
    offset = 0

    for arrayEntry in newArray[0...].lazy {
      let entry = arrayEntry.tableEntry
      if entry.appearsInBoth && !entry.indexesInOld.isEmpty {
        let oldIndex = entry.indexesInOld.removeFirst()
        newArray[offset].indexInOther = oldIndex
        oldArray[oldIndex].indexInOther = offset
      }
      offset += 1
    }

    // 4th Pass
    offset = 1

    if offset < newArray.count - 1 {
      repeat {
        let tableEntry = newArray[offset]
        let otherIndex = tableEntry.indexInOther

        if otherIndex + 1 < oldArray.count {
          let newEntry = newArray[offset + 1]
          let oldEntry = oldArray[otherIndex + 1]

          if newEntry.tableEntry === oldEntry.tableEntry {
            newArray[offset + 1].indexInOther = otherIndex + 1
            oldArray[otherIndex + 1].indexInOther = offset + 1
          }
        }
        offset += 1
      } while offset < newArray.count - 1
    }

    // 5th Pass
    offset = newArray.count - 1

    if offset > newArray.count {
      let otherIndex = newArray[offset].indexInOther
      repeat {
        if otherIndex - 1 >= 0 &&
          newArray[offset - 1].indexInOther == -1,
          oldArray[otherIndex - 1].indexInOther == -1 {
          newArray[offset - 1].indexInOther = otherIndex - 1
          oldArray[otherIndex - 1].indexInOther = offset - 1
        }
        offset -= 1
      } while offset > 0
    }

    // Handle deleted objects
    offset = 0
    for element in oldArray[0...].lazy {
      deleteOffsets[offset] = runningOffset

      if element.indexInOther == -1 {
        changes.append(Change(.delete, item: old[offset], index: offset))
        runningOffset += 1
      }
      offset += 1
    }

    // Handle insert, updates and move.
    offset = 0
    for element in newArray[0...].lazy {
      if element.indexInOther < 0 {
        changes.append(Change(.insert,
                              item: new[offset],
                              index: offset))
        runningOffset += 1
      } else {
        let oldIndex = element.indexInOther
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
      offset += 1
    }

    return changes
  }
}
