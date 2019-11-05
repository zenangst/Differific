import UIKit

public extension UITableView {
  /// Reload table view's data source with a collection of changes.
  ///
  /// - Parameters:
  ///   - changes: A generic collection of changes.
  ///   - animation: The animation that should be used when performing the update.
  ///   - section: The section that will be updated.
  ///   - before: A closure that will be invoked before the updates.
  ///             This is where you should update your data source.
  ///   - completion: A closure that is invoked after the updates are done.
  func reload<T: Hashable>(with changes: [Change<T>],
                           animation: UITableView.RowAnimation = .automatic,
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

    setNeedsLayout()
    layoutIfNeeded()

    let manager = IndexPathManager()
    let result = manager.process(changes, section: section)

    if #available(iOS 11, tvOS 11, *) {
      performBatchUpdates({
        updateDataSource()
        validateUpdates(result.insert, animation: animation, then: insertRows)
        validateUpdates(result.updates, animation: animation, then: reloadRows)
        validateUpdates(result.deletions, animation: animation, then: deleteRows)
        if !result.moves.isEmpty {
          result.moves.forEach { moveRow(at: $0.from, to: $0.to) }
        }
      })
    } else {
      beginUpdates()
      updateDataSource()
      validateUpdates(result.insert, animation: animation, then: insertRows)
      validateUpdates(result.updates, animation: animation, then: reloadRows)
      validateUpdates(result.deletions, animation: animation, then: deleteRows)
      if !result.moves.isEmpty {
        result.moves.forEach { moveRow(at: $0.from, to: $0.to) }
      }
      endUpdates()
    }

    completion?()
  }

  private func validateUpdates(_ collection: [IndexPath],
                               animation: UITableView.RowAnimation,
                               then: ([IndexPath], UITableView.RowAnimation) -> Void) {
    if !collection.isEmpty { then(collection, animation) }
  }
}
