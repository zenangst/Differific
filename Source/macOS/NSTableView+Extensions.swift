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
  func reload<T: Hashable>(with changes: [Change<T>],
                           animation: NSTableView.AnimationOptions,
                           section: Int = 0,
                           updateDataSource: (() -> Void),
                           completion: (() -> Void)? = nil) {
    guard !changes.isEmpty else {
      completion?()
      return
    }

    if superview == nil {
      updateDataSource()
      reloadData()
      return
    }
    
    let manager = IndexPathManager()
    let result = manager.process(changes, section: section)
    let insertions = IndexSet(result.insert.compactMap { $0.item })
    let deletions = IndexSet(result.deletions.compactMap { $0.item })
    let updates = IndexSet(result.updates.compactMap { $0.item })
    
    animator().beginUpdates()
    updateDataSource()
    validateUpdates(insertions, animation: animation, then: animator().insertRows)
    validateUpdates(deletions, animation: animation, then: animator().removeRows)

    if !updates.isEmpty {
      animator().reloadData(forRowIndexes: updates, columnIndexes: IndexSet([section]))
    }

    if !result.moves.isEmpty {
      result.moves.forEach { animator().moveRow(at: $0.from.item, to: $0.to.item) }
    }

    animator().endUpdates()

    needsLayout = true

    completion?()
  }

  private func validateUpdates(_ collection: IndexSet,
                               animation: NSTableView.AnimationOptions,
                               then: (IndexSet, NSTableView.AnimationOptions) -> Void) {
    if !collection.isEmpty { then(collection, animation) }
  }
}
