//
// Copyright 2025 macoonshine
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
//

/// A prefix trie.
public struct PrefixTrie<Value>: Trie {
    typealias Node = SubstringTrieNode<Value>
    typealias Nodes = [Character: Node]
        
    var root = Node()
    
    public init() {
    }
     
    /// Returns true if and only if this trie contains no value.
    public var isEmpty: Bool {
        root.isEmpty
    }
    
    /// Returns the number of all values contained in this trie.
    public var count: Int {
        root.count
    }
    
    /// Gets or sets the value for the given key. Setting nil as value will remove the value for the key.
    public subscript<Key>(key: Key) -> Value? where Key: StringProtocol {
        get {
            root.value(for: key)
        }
        set {
            if let value = newValue {
                root.insert(key, value)
            }
            else {
                root.remove(key, all: false)
            }
        }
    }
    
    /// Returns true if and only if this trie contains values for the given prefix.
    public func contains<Key>(any prefix: Key) -> Bool where Key: StringProtocol {
        root.contains(prefix, isPrefix: true)
    }
    
    /// Returns true if and only if this trie contains a value for the given key.
    public func contains<Key>(_ key: Key) -> Bool where Key: StringProtocol {
        root.contains(key, isPrefix: false)
    }

    /// Returns all values that can be reached via the specified prefix. The order of the elements in the result is undefined.
    public func values<Prefix>(for prefix: Prefix) -> Values where Prefix: StringProtocol {
        root.values(for: prefix)
    }
    
    /// Adds the specified value to the specified key in this trie.
    public mutating func insert<Key>(_ key: Key, _ value: Value) where Key: StringProtocol {
        root.insert(key, value)
    }
    
    /// Removes the value that can be reached via the specified key.
    public mutating func remove<Key>(_ key: Key) where Key: StringProtocol {
        root.remove(key, all: false)
    }
    
    /// Removes all values that can be reached via the specified prefix.
    public mutating func remove<Key>(all prefix: Key) where Key: StringProtocol {
        root.remove(prefix, all: true)
    }
    
    /// Returns a dictionary containing all key-value pairs from this trie.
    public func dictionary() -> [String: Value] {
        var result: [String: Value] = [:]
        
        root.dictionary(prefix: "", &result)
        return result
    }
}

extension PrefixTrie: Sendable where Value: Sendable {
}

extension PrefixTrie: Codable where Value: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([String: Value].self)
        
        for (key, value) in values {
            insert(key, value)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        let values = dictionary()
        var container = encoder.singleValueContainer()
        
        try container.encode(values)
    }
}

extension PrefixTrie: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Value)...) {
        for (key, value) in elements {
            insert(key, value)
        }
    }
}

extension PrefixTrie: ExpressibleByArrayLiteral where Value == String {
    /// Initializes the trie with the specified string array where each string is used as key and value.
    ///
    /// - Parameter strings array with keys
    ///
    public init(_ strings: [String]) {
        for s in strings {
            insert(s, s)
        }
    }
    
    /// Initializes the trie with the specified strings where each string is used as key and value.
    ///
    /// - Parameter strings array with keys
    ///
    public init(_ strings: String...) {
        self.init(strings)
    }
    
    public init(arrayLiteral strings: String...) {
        self.init(strings)
    }
}
