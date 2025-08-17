//
// Copyright 2025 macoonshine
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
//

struct CharacterTrieNode<Value> {
    typealias Values = [Value]
    typealias TrieNodes = [Character: CharacterTrieNode]
    
    let character: Character
    var children: TrieNodes = TrieNodes()
    var value: Value?
    var count: Int
    
    init() {
        character = "\0"
        value = nil
        count = 0
    }
    
    init(character: Character, value: Value? = nil) {
        self.character = character
        self.value = value
        self.count = value == nil ? 0 : 1
    }
    
    var isEmpty: Bool {
        value == nil && children.isEmpty
    }
    
    func contains<Suffix>(_ suffix: Suffix, isPrefix: Bool = false) -> Bool where Suffix: StringProtocol {
        if let first = suffix.first {
            guard let child = child(for: first) else { return false }
            
            return child.contains(suffix.remainder)
        }
        else {
            return isPrefix || !isEmpty
        }
    }
    
    func child(for character: Character) -> CharacterTrieNode? {
        children[character]
    }
    
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
    
    func value<Suffix>(for suffix: Suffix) -> Value? where Suffix: StringProtocol {
        if let first = suffix.first {
            guard let child = child(for: first) else { return nil }
            
            return child.value(for: suffix.remainder)
        }
        else {
            return value
        }
    }
    
    func values<Suffix>(for suffix: Suffix) -> Values where Suffix: StringProtocol {
        if let first = suffix.first {
            guard let child = child(for: first) else { return Values() }
            
            return child.values(for: suffix.remainder)
        }
        else {
            return collectValues()
        }
    }
    
    mutating func insert<Suffix>(_ suffix: Suffix, _ value: Value) where Suffix: StringProtocol {
        if let first = suffix.first {
            var child = child(for: first) ?? CharacterTrieNode(character: first)
            
            child.insert(suffix.remainder, value)
            children[first] = child
        }
        else {
            self.value = value
        }
        updateCount()
    }
    
    @discardableResult
    mutating func remove<Suffix>(_ suffix: Suffix, all: Bool) -> Bool where Suffix: StringProtocol {
        if let first = suffix.first {
            guard var child = child(for: first) else { return isEmpty }
            
            if child.remove(suffix.remainder, all: all) {
                children.removeValue(forKey: first)
            }
            else {
                children[first] = child
            }
            updateCount()
            return isEmpty
        }
        else {
            value = nil
            updateCount()
            return all || isEmpty
        }
    }
    
    func dictionary(prefix: String, _ values: inout [String: Value]) {
        if let value = value {
            values[prefix] = value
        }
        for (character, child) in children {
            child.dictionary(prefix: prefix + String(character), &values)
        }
    }
}

extension CharacterTrieNode: Sendable where Value: Sendable {
}

fileprivate extension StringProtocol {
    var remainder: Self.SubSequence {
        suffix(count - 1)
    }
}
