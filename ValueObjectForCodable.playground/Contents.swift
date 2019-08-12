import Foundation

protocol ValueObject: Codable, CustomStringConvertible, Equatable {
  associatedtype Value: Codable, CustomStringConvertible, Equatable
  
  var value: Value { get }
  
  init(value: Value)
}

extension ValueObject {
  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let value = try container.decode(Value.self)
    self.init(value: value)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(value)
  }
  
  var description: String {
    return value.description
  }
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.value == rhs.value
  }
}

struct UserID: ValueObject {
  let value: Int
  
  init(value: Int) {
    self.value = value
  }
}

struct User: Codable {
  let id: UserID
  let name: String
  let age: Int
}


let json = """
{
  "id" : 1234,
  "name" : "maguhiro",
  "age" : 34
}
""".data(using: .utf8)!
let user = try! JSONDecoder().decode(User.self, from: json)

print("\(user.id)")

