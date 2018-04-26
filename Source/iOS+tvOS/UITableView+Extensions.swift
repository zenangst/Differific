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
    beginUpdates()

    if !result.insert.isEmpty {
      insertRows(at: result.insert, with: animation)
    }

    if !result.updates.isEmpty {
      reloadRows(at: result.updates, with: animation)
    }

    if !result.deletions.isEmpty {
      deleteRows(at: result.deletions, with: animation)
    }

    if !result.moves.isEmpty {
      result.moves.forEach { moveRow(at: $0.from, to: $0.to) }
    }

    endUpdates()

    completion?()
  }
}
