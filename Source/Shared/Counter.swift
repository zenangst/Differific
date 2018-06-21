import Foundation

enum Counter {
  case zero, one, many

  func increment() -> Counter {
    switch self {
    case .zero:
      return .one
    case .one:
      return .many
    case .many:
      return self
    }
  }
}
