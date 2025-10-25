//
// Copyright 2025 macoonshine
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
//

/// A sorted array that functions like a prefix trie.
public struct PrefixArray<Value>: Trie {
    typealias Entry = (key: String, value: Value)
    var array = [Entry]()
    
    public var isEmpty: Bool {
        array.isEmpty
    }
    
    public var count: Int {
        array.count
    }
    
    func index<Key>(key: Key, isPrefix: Bool = false) -> Array.Index? where Key : StringProtocol {
        let key = String(key)
        guard let index = array.bisectFirstIndex(where: { $0.key >= key }) else { return nil }
        let firstKey = array[index].key
        
        return key == firstKey || isPrefix && firstKey.hasPrefix(key) ? index : nil
    }
    
    func range<Key>(prefix: Key) -> Range<Array.Index>? where Key : StringProtocol {
        guard let index = index(key: prefix, isPrefix: true) else { return nil }
        let key = String(prefix)
        
        if index + 1 < array.count,
           let endIndex = array.bisectFirstIndex(where: {
               $0.key > key && !$0.key.hasPrefix(key)
           }) {
            return index..<endIndex
        }
        else if let last = array.last, last.key.hasPrefix(key) {
            return index..<array.count
        }
        else {
            return index..<index + 1
        }
    }
    
    public subscript<Key>(key: Key) -> Value? where Key : StringProtocol {
        get {
            guard let index = self.index(key: key) else { return nil }
            
            return array[index].value
        }
        set {
            if let value = newValue {
                insert(key, value)
            }
            else {
                remove(key)
            }
        }
    }
    
    public func contains<Key>(any prefix: Key) -> Bool where Key : StringProtocol {
        index(key: prefix, isPrefix: true) != nil
    }
    
    public func contains<Key>(_ key: Key) -> Bool where Key : StringProtocol {
        index(key: key) != nil
    }
    
    public func values<Key>(for key: Key) -> Values where Key : StringProtocol {
        guard let range = range(prefix: key) else { return [] }
        
        return array[range].map { $0.value }
    }
    
    public mutating func insert<Key>(_ key: Key, _ value: Value) where Key : StringProtocol {
        let key = String(key)

        if let index = array.bisectFirstIndex(where: { $0.key >= key }) {
            if array[index].key == key {
                array[index].value = value
            }
            else {
                let index = array[index].key < key ? index + 1 : index
                
                array.insert((String(key), value), at: index)
            }
        }
        else {
            array.append((key, value))
        }
    }
    
    public mutating func remove<Key>(_ key: Key) where Key : StringProtocol {
        guard let index = index(key: key) else { return }
        
        array.remove(at: index)
    }
    
    public mutating func remove<Key>(all key: Key) where Key : StringProtocol {
        guard let range = range(prefix: key) else { return }
            
        array.removeSubrange(range)
    }
    
    public func dictionary() -> [String : Value] {
        array.reduce(into: [String: Value]()) {
            $0[$1.key] = $1.value
        }
    }
}

extension PrefixArray: Sendable where Value: Sendable {
}

extension PrefixArray: Codable where Value: Codable {
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

extension PrefixArray: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, Value)...) {
        array = elements.sorted { $0.0 < $1.0 }
    }
}

extension PrefixArray: ExpressibleByArrayLiteral where Value == String {
    /// Initializes the trie with the specified string array where each string is used as key and value.
    ///
    /// - Parameter strings array with keys
    ///
    public init(_ strings: [String]) {
        array = strings.sorted().map { ($0, $0) }
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
