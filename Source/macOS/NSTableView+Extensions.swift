import Cocoa

public extension NSTableView {
  public func reload<T: Hashable>(with changes: [Change<T>],
                                  animation: NSTableView.AnimationOptions,
                                  section: Int = 0,
                                  before: ((NSTableView) -> Void)? = nil,
                                  completion: (() -> Void)? = nil) {
    guard !changes.isEmpty else {
      completion?()
      return
    }

    let manager = IndexPathManager()
    let result = manager.process(changes, section: section)
    let insertions = IndexSet(result.insert.compactMap { $0.item })
    let deletions = IndexSet(result.deletions.compactMap { $0.item })
    let updates = IndexSet(result.updates.compactMap { $0.item })

    before?(self)

    beginUpdates()
    removeRows(at: deletions, withAnimation: animation)
    insertRows(at: insertions, withAnimation: animation)
    reloadData(forRowIndexes: updates, columnIndexes: IndexSet([section]))
    result.moves.forEach { moveRow(at: $0.from.item, to: $0.to.item) }
    endUpdates()

    completion?()
  }
}
