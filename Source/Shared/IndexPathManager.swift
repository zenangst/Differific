#if os(macOS)
import Cocoa
#else
import UIKit
#endif

class IndexPathManager {
  func process<T>(_ changeSet: [Change<T>],
                  section: Int = 0) -> (insert: [IndexPath],
                                        updates: [IndexPath],
                                        deletions: [IndexPath],
                                        moves: [(from: IndexPath, to: IndexPath)]) {
    let deletions = map(.delete, in: changeSet, section: section)
    let insertions = map(.insert, in: changeSet, section: section)
    let updates = map(.replace, in: changeSet, section: section)
    let moves = changeSet.filter { $0.kind == .move }.compactMap {
      (from: IndexPath(item: $0.index, section: section),
       to: IndexPath(item: $0.newIndex!, section: section))
    }

    return (insertions, updates, deletions, moves)
  }

  private func map<T>(_ kind: Change<T>.Kind,
                      in changeSet: [Change<T>],
                      section: Int = 0) -> [IndexPath] {
    return changeSet.filter { $0.kind == kind }
      .compactMap { IndexPath(item: $0.index, section: section) }
  }
}
