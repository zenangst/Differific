import UIKit

extension UICollectionView {
  public func reload<T: Hashable>(with changes: [Change<T>],
                                  section: Int = 0,
                                  before: ((UICollectionView) -> Void)? = nil,
                                  completion: (() -> Void)? = nil) {
    guard !changes.isEmpty else {
      completion?()
      return
    }

    let manager = IndexPathManager()
    let result = manager.process(changes, section: section)

    before?(self)

    performBatchUpdates({
      insertItems(at: result.insert)
      reloadItems(at: result.updates)
      deleteItems(at: result.deletions)
      result.moves.forEach {
        moveItem(at: $0.from, to: $0.to)
      }
    }, completion: nil)

    completion?()
  }
}
