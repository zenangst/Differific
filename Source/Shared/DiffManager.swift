import Foundation

public class DiffManager {
  public init() {}
  public func diff<T: Hashable>(_ old: [T], _ new: [T],
                                compare: (T,T) -> Bool = { $0 == $1 }) -> [Change<T>] {
    return Algorithm.diff(old: old, new: new, compare: compare)
  }
}
