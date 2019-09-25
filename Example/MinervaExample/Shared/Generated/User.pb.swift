// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: User.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

struct UserProto {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var userID: String {
    get {return _userID ?? String()}
    set {_userID = newValue}
  }
  /// Returns true if `userID` has been explicitly set.
  var hasUserID: Bool {return self._userID != nil}
  /// Clears the value of `userID`. Subsequent reads from it will return its default value.
  mutating func clearUserID() {self._userID = nil}

  var email: String {
    get {return _email ?? String()}
    set {_email = newValue}
  }
  /// Returns true if `email` has been explicitly set.
  var hasEmail: Bool {return self._email != nil}
  /// Clears the value of `email`. Subsequent reads from it will return its default value.
  mutating func clearEmail() {self._email = nil}

  var dailyCalories: Int32 {
    get {return _dailyCalories ?? 0}
    set {_dailyCalories = newValue}
  }
  /// Returns true if `dailyCalories` has been explicitly set.
  var hasDailyCalories: Bool {return self._dailyCalories != nil}
  /// Clears the value of `dailyCalories`. Subsequent reads from it will return its default value.
  mutating func clearDailyCalories() {self._dailyCalories = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _userID: String? = nil
  fileprivate var _email: String? = nil
  fileprivate var _dailyCalories: Int32? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension UserProto: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "UserProto"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "userID"),
    2: .same(proto: "email"),
    3: .same(proto: "dailyCalories"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularStringField(value: &self._userID)
      case 2: try decoder.decodeSingularStringField(value: &self._email)
      case 3: try decoder.decodeSingularInt32Field(value: &self._dailyCalories)
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._userID {
      try visitor.visitSingularStringField(value: v, fieldNumber: 1)
    }
    if let v = self._email {
      try visitor.visitSingularStringField(value: v, fieldNumber: 2)
    }
    if let v = self._dailyCalories {
      try visitor.visitSingularInt32Field(value: v, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: UserProto, rhs: UserProto) -> Bool {
    if lhs._userID != rhs._userID {return false}
    if lhs._email != rhs._email {return false}
    if lhs._dailyCalories != rhs._dailyCalories {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
