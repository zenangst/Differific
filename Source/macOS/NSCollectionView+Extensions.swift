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
  func reload<T: Hashable>(with changes: [Change<T>],
                           animations: Bool = false,
                           section: Int = 0,
                           updateDataSource: (() -> Void),
                           completion: (() -> Void)? = nil) {
    guard !changes.isEmpty else {
      completion?()
      return
    }

    let manager = IndexPathManager()
    let result = manager.process(changes, section: section)
    let object = animations ? animator() : self

    object.performBatchUpdates({
      updateDataSource()
      validateUpdates(result.insert, then: object.insertItems)
      validateUpdates(result.updates, then: object.reloadItems)
      validateUpdates(result.deletions, then: object.deleteItems)
      if !result.moves.isEmpty {
        result.moves.forEach { object.moveItem(at: $0.from, to: $0.to) }
      }
    }, completionHandler: nil)

    completion?()
  }

  private func validateUpdates(_ collection: [IndexPath], then: (Set<IndexPath>) -> Void) {
    if !collection.isEmpty { then(Set(collection)) }
  }
}
