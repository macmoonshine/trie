//
// Copyright 2025 macoonshine
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
//

struct SubstringTrieNode<Value> {
    typealias Values = [Value]
    typealias TrieNodes = [Character: Self]
        
    var part: String
    var children: TrieNodes = TrieNodes()
    var value: Value?
    var count: Int

    init() {
        part = ""
        value = nil
        count = 0
    }
    
    init<S>(part: S, value: Value? = nil) where S : StringProtocol {
        self.part = String(part)
        self.value = value
        self.count = value == nil ? 0 : 1
    }
    
    var isEmpty: Bool {
        value == nil && children.isEmpty
    }
    
    func contains<Suffix>(_ suffix: Suffix, isPrefix: Bool = false) -> Bool where Suffix: StringProtocol {
        if let node = child(for: suffix, isPrefix: isPrefix) {
            guard let remainder = suffix.suffix(at: node.part.count),
                    !remainder.isEmpty else {
                return node.value != nil || isPrefix && !node.isEmpty
            }
            
            return node.contains(remainder, isPrefix: isPrefix)
        }
        else {
            return suffix.isEmpty && (isPrefix || !isEmpty)
        }
    }
    
    func child<Suffix>(for part: Suffix, isPrefix: Bool = false) -> Self? where Suffix : StringProtocol {
        guard let first = part.first, let node = children[first] else {
            return nil
        }
        
        if part.hasPrefix(node.part) || isPrefix && node.part.hasPrefix(part) {
            return node
        }
        else {
            return nil
        }
    }
    
    @discardableResult
    mutating func set(node: Self) -> Bool {
        guard let first = node.part.first, children[first] == nil else {
            return false
        }
            
        children[first] = node
        return true
    }
    
    func value<Suffix>(for suffix: Suffix) -> Value? where Suffix: StringProtocol {
        if let node = child(for: suffix) {
            guard let remainder = suffix.suffix(at: node.part.count) else {
                return nil
            }

            return node.value(for: remainder)
        }
        else {
            return suffix.isEmpty ? value : nil
        }
    }

    func values<Suffix>(for suffix: Suffix) -> Values where Suffix: StringProtocol {
        if let node = child(for: suffix, isPrefix: true) {
            if let remainder = suffix.suffix(at: node.part.count) {
                return node.values(for: remainder)
            }
            else {
                return node.collectValues()
            }
        }
        else {
            return suffix.isEmpty ? collectValues() : []
        }
    }

    mutating func insert<Suffix>(_ suffix: Suffix, _ value: Value) where Suffix: StringProtocol {
        if let first = suffix.first {
            if var node = children[first] {
                let part = node.part
                let prefix = part.prefix(common: suffix)
                let length = prefix.count
                
                switch (part.count, suffix.count) {
                case (length, length):
                    node.value = value
                case (length, _):
                    let remainder = suffix.suffix(at: length)!
                    
                    node.insert(remainder, value)
                case (_, length):
                    let remainder = part.suffix(at: length)!
                    var newNode = Self(part: prefix, value: value)
                    
                    node.part = String(remainder)
                    newNode.set(node: node)
                    node = newNode
                    node.updateCount()
                default:
                    let partRemainder = part.suffix(at: length)!
                    let suffixRemainder = suffix.suffix(at: length)!
                    var newNode = Self(part: prefix)

                    node.part = String(partRemainder)
                    newNode.set(node: node)
                    newNode.insert(suffixRemainder, value)
                    node = newNode
                }
                children[first] = node
            }
            else {
                children[first] = Self(part: suffix, value: value)
            }
        }
        else {
            self.value = value
        }
        updateCount()
    }
    
    @discardableResult
    mutating func remove<Suffix>(_ suffix: Suffix, all: Bool) -> Bool where Suffix: StringProtocol {
        if let first = suffix.first {
            guard var node = children[first] else { return isEmpty }
            let part = node.part
            
            if all && part.hasPrefix(suffix) {
                children.removeValue(forKey: first)
            }
            else if suffix.hasPrefix(part) {
                let remainder = suffix.suffix(at: part.count)!
                
                node.remove(remainder, all: all)
                children[first] = node
            }
        }
        else {
            value = nil
        }
        updateCount()
        return all || isEmpty
    }
    
    func dictionary(prefix: String, _ values: inout [String: Value]) {
        if let value = value {
            values[prefix] = value
        }
        for node in children.values {
            let prefix = prefix + node.part
            
            node.dictionary(prefix: prefix, &values)
        }
    }

    // copied
    
    private func collectValues() -> Values {
        var values = Values()
        
        if let value = value {
            values.append(value)
        }
        for child in children.values {
            values.append(contentsOf: child.collectValues())
        }
        return values
    }

    private mutating func updateCount() {
        count = value == nil ? 0 : 1
        count += children.values.reduce(0) { $0 + $1.count }
    }
}

extension SubstringTrieNode: Sendable where Value: Sendable {
}
