import UIKit

public extension UITableView {
  public func reload<T: Hashable>(with changes: [Change<T>],
                                  animation: UITableViewRowAnimation = .automatic,
                                  section: Int = 0,
                                  before: ((UITableView) -> Void)? = nil,
                                  completion: (() -> Void)? = nil) {
    guard !changes.isEmpty else {
      completion?()
      return
    }

    let manager = IndexPathManager()
    let result = manager.process(changes, section: section)

    before?(self)

    if #available(iOS 11, tvOS 11, *) {
      performBatchUpdates({
        insertRows(at: result.insert, with: animation)
        reloadRows(at: result.updates, with: animation)
        deleteRows(at: result.deletions, with: animation)
        result.moves.forEach { moveRow(at: $0.from, to: $0.to) }
      })
    } else {
      beginUpdates()
      insertRows(at: result.insert, with: animation)
      reloadRows(at: result.updates, with: animation)
      deleteRows(at: result.deletions, with: animation)
      result.moves.forEach { moveRow(at: $0.from, to: $0.to) }
      endUpdates()
    }

    completion?()
  }
}
