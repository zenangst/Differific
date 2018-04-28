import Cocoa

public extension NSCollectionView {
  /// Reload collection view's data source with a collection of changes.
  ///
  /// - Parameters:
  ///   - changes: A generic collection of changes.
  ///   - section: The section that will be updated.
  ///   - before: A closure that will be invoked before the updates.
  ///   - completion: A closure that is invoked after the updates are done.
  public func reload<T: Hashable>(with changes: [Change<T>],
                                  section: Int = 0,
                                  before: ((NSCollectionView) -> Void)? = nil,
                                  completion: (() -> Void)? = nil) {
    guard !changes.isEmpty else {
      completion?()
      return
    }

    let manager = IndexPathManager()
    let result = manager.process(changes, section: section)

    before?(self)

    performBatchUpdates({
      insertItems(at: Set(result.insert))
      reloadItems(at: Set(result.updates))
      deleteItems(at: Set(result.deletions))
      result.moves.forEach { moveItem(at: $0.from, to: $0.to) }
    }, completionHandler: nil)

    completion?()
  }
}
