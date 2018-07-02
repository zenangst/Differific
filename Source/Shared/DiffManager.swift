import Foundation

public class DiffManager {
  public init() {}
  public func diff<T: Hashable>(_ old: [T], _ new: [T]) -> [Change<T>] {
    return Algorithm.diff(old: old, new: new)
  }
}
