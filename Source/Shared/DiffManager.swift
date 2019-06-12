import Foundation

public class DiffManager {
  public init() {}
  public func diff<T: Hashable>(_ old: [T], _ new: [T],
                                compare: (T,T) -> Bool = { lhs, rhs in
    if let lhs = lhs as? Diffable, let rhs = rhs as? Diffable {
      return lhs.diffValue == rhs.diffValue
    } else {
      return lhs == rhs
    }}) -> [Change<T>] {
    return Algorithm.diff(old: old, new: new, compare: compare)
  }
}
