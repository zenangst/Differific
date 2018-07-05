import Foundation

public struct Change<T: Equatable> {
  public enum Kind {
    case insert, delete, update, move
  }

  public let kind: Kind
  public let item: T
  public let index: Int
  public var newIndex: Int?
  public var newItem: T?

  init(_ kind: Change.Kind,
       item: T,
       index: Int,
       newIndex: Int? = nil,
       newItem: T? = nil) {
    self.kind = kind
    self.item = item
    self.index = index
    self.newIndex = newIndex
    self.newItem = newItem
  }
}
