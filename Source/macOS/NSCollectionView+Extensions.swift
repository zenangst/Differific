import Cocoa

public extension NSCollectionView {
  /// Reload collection view's data source with a collection of changes.
  ///
  /// - Parameters:
  ///   - changes: A generic collection of changes.
  ///   - section: The section that will be updated.
  ///   - before: A closure that will be invoked before the updates.
  ///             This is where you should update your data source.
  ///   - completion: A closure that is invoked after the updates are done.
  public func reload<T: Hashable>(with changes: [Change<T>],
                                  section: Int = 0,
                                  updateDataSource: (() -> Void),
                                  completion: (() -> Void)? = nil) {
    guard !changes.isEmpty else {
      completion?()
      return
    }

    let manager = IndexPathManager()
    let result = manager.process(changes, section: section)

    animator().performBatchUpdates({
      updateDataSource()
      validateUpdates(result.insert, then: animator().insertItems)
      validateUpdates(result.updates, then: animator().reloadItems)
      validateUpdates(result.deletions, then: animator().deleteItems)
      if !result.moves.isEmpty {
        result.moves.forEach { animator().moveItem(at: $0.from, to: $0.to) }
      }
    }, completionHandler: nil)

    completion?()
  }

  private func validateUpdates(_ collection: [IndexPath], then: (Set<IndexPath>) -> Void) {
    if !collection.isEmpty { then(Set(collection)) }
  }
}
