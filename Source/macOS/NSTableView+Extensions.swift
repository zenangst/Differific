import Cocoa

public extension NSTableView {
  /// Reload table views data source with a collection of changes.
  ///
  /// - Parameters:
  ///   - changes: A generic collection of changes.
  ///   - animation: The animation that should be used when performing the update.
  ///   - section: The section that will be updated.
  ///   - before: A closure that will be invoked before the updates.
  ///             This is where you should update your data source.
  ///   - completion: A closure that is invoked after the updates are done.
  public func reload<T: Hashable>(with changes: [Change<T>],
                                  animation: NSTableView.AnimationOptions,
                                  section: Int = 0,
                                  updateDataSource: (() -> Void),
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


    beginUpdates()
    updateDataSource()
    removeRows(at: deletions, withAnimation: animation)
    insertRows(at: insertions, withAnimation: animation)
    reloadData(forRowIndexes: updates, columnIndexes: IndexSet([section]))
    result.moves.forEach { moveRow(at: $0.from.item, to: $0.to.item) }
    endUpdates()

    completion?()
  }
}
