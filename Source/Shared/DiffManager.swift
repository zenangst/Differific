import Foundation

public class DiffManager {
  public init() {}
  public func diff<T: Hashable>(_ old: [T], _ new: [T]) -> [Change<T>] {
    let algorithm = Algorithm()
    let result = algorithm.diff(old: old, new: new)
    return result
  }
}
