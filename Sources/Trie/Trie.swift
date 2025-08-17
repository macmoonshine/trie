//
// Copyright 2025 macoonshine
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
//

/// A  trie.
public protocol Trie {
    associatedtype Value
    typealias Values = [Value]

    /// Returns true if and only if this trie contains no value.
    var isEmpty: Bool { get }
    
    /// Returns the number of all values contained in this trie.
    var count: Int { get }
    
    /// Gets or sets the value for the given key. Setting nil as value will remove the value for the key.
    subscript<Key>(key: Key) -> Value? where Key: StringProtocol { get set }

    /// Returns true if and only if this trie contains values for the given prefix.
    func contains<Key>(any prefix: Key) -> Bool where Key: StringProtocol
    
    /// Returns true if and only if this trie contains a value for the given key.
    func contains<Key>(_ key: Key) -> Bool where Key: StringProtocol
    
    /// Returns all values that can be reached via the specified key. The order of the elements in the result is undefined.
    func values<Key>(for key: Key) -> Values where Key: StringProtocol
    
    /// Adds the specified value to the specified key in this trie.
    mutating func insert<Key>(_ key: Key, _ value: Value) where Key: StringProtocol
    
    /// Removes the value that can be reached via the specified key.
    mutating func remove<Key>(_ key: Key) where Key: StringProtocol
    
    /// Removes all values that can be reached via the specified key.
    mutating func remove<Key>(all key: Key) where Key: StringProtocol
    
    /// Returns a dictionary containing all key-value pairs from this trie.
    func dictionary() -> [String: Value]
}
