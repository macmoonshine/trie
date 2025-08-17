//
// Copyright 2025 macoonshine
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
//

import Testing
@testable import Trie

let PREFIX_KEYWORDS = [
    "Any", "as", "associatedtype", "await", "borrowing", "break", "case",
    "catch", "class", "consuming", "continue", "default", "defer", "deinit",
    "do", "else", "enum", "extension", "fallthrough", "false", "fileprivate",
    "for", "func", "guard", "if", "import", "in", "init", "inout", "internal",
    "is", "let", "nil", "nonisolated", "open", "operator", "precedencegroup",
    "private", "protocol", "public", "repeat", "rethrows", "return",
    "self", "Self", "static", "struct", "subscript", "super", "switch","throw",
    "throws", "true", "try", "typealias", "var", "where", "while"
]

func createPrefixTrie(_ length: Int = PREFIX_KEYWORDS.count) -> PrefixTrie<String> {
    var trie = PrefixTrie<String>()
    
    for keyword in PREFIX_KEYWORDS.prefix(length) {
        trie.insert(keyword, keyword)
    }
    return trie
}

@Test func PrefixTrie_values() async throws {
    let trie = createPrefixTrie()
    
    #expect(trie.count == PREFIX_KEYWORDS.count)
    #expect(trie.values(for: "").sorted() == PREFIX_KEYWORDS.sorted())
    #expect(trie.values(for: "z") == [])
    #expect(trie.values(for: "v") == ["var"])
    #expect(trie.values(for: "wh").sorted() == ["where", "while"])
    #expect(trie.values(for: "whi") == ["while"])
    #expect(trie.values(for: "wha") == [])
}

@Test func PrefixTrie_insert() async throws {
    var trie = createPrefixTrie()
    
    #expect(trie.count == PREFIX_KEYWORDS.count)
    #expect(trie.contains(any: "T") == false)
    #expect(trie.contains("T") == false)
    #expect(trie.values(for: "T") == [])
    trie.insert("Type", "Type")
    #expect(trie.count == PREFIX_KEYWORDS.count + 1)
    #expect(trie.contains("T") == false)
    #expect(trie.contains(any: "T") == true)
    #expect(trie.values(for: "T") == ["Type"])
}

@Test func PrefixTrie_remove() async throws {
    var trie = createPrefixTrie()
    
    #expect(trie.count == PREFIX_KEYWORDS.count)
    #expect(trie.contains("as") == true)
    #expect(trie.values(for: "as").sorted() == ["as", "associatedtype"])
    trie.remove("as")
    #expect(trie.count == PREFIX_KEYWORDS.count - 1)
    #expect(trie.contains("as") == true)
    #expect(trie.values(for: "as") == ["associatedtype"])
    
    trie = createPrefixTrie()
    
    #expect(trie.contains("associatedtype") == true)
    #expect(trie.values(for: "as").sorted() == ["as", "associatedtype"])
    trie.remove("ass")
    #expect(trie.count == PREFIX_KEYWORDS.count)
    #expect(trie.contains("associatedtype") == true)
    #expect(trie.values(for: "as").sorted() == ["as", "associatedtype"])
    trie.remove("associatedtype")
    #expect(trie.count == PREFIX_KEYWORDS.count - 1)
    #expect(trie.contains("associatedtype") == false)
    #expect(trie.values(for: "as").sorted() == ["as"])
    
    trie = createPrefixTrie()
    
    trie.remove(all: "ass")
    #expect(trie.count == PREFIX_KEYWORDS.count - 1)
    #expect(trie.contains("associatedtype") == false)
    #expect(trie.values(for: "as").sorted() == ["as"])
    
    trie.remove(all: "a")
    #expect(trie.count == PREFIX_KEYWORDS.count - 3)
    #expect(trie.values(for: "a") == [])
}

@Test func PrefixTrie_smallDictionary() async throws {
    let keywords = ["else", "enum"]
    let trie = PrefixTrie(keywords)
    let dictionary = trie.dictionary()
    
    #expect(dictionary.count == keywords.count)
    #expect(dictionary.keys.sorted() == keywords.sorted())
    for (key, value) in dictionary {
        #expect(keywords.contains(key))
        #expect(key == value)
    }
}

@Test func PrefixTrie_dictionary() async throws {
    let trie = createPrefixTrie()
    let dictionary = trie.dictionary()
    
    #expect(dictionary.count == PREFIX_KEYWORDS.count)
    #expect(dictionary.keys.sorted() == PREFIX_KEYWORDS.sorted())
    for (key, value) in dictionary {
        #expect(PREFIX_KEYWORDS.contains(key))
        #expect(key == value)
    }
}

@Test func PrefixTrie_dictionaryLiteral() async throws {
    let trie: PrefixTrie<String> = ["apple": "red", "banana": "yellow", "apricot": "orange"]
    
    #expect(trie.count == 3)
    #expect(trie.values(for: "a").sorted() == ["orange", "red"])
    #expect(trie.values(for: "apr") == ["orange"])
    #expect(trie.values(for: "app") == ["red"])
}

@Test func PrefixTrie_subscript() async throws {
    var trie: PrefixTrie<String> = ["apple": "red", "banana": "yellow", "apricot": "orange"]
    
    #expect(trie["apple"] == "red")
    #expect(trie["banana"] == "yellow")
    #expect(trie["apricot"] == "orange")
    #expect(trie["ap"] == nil)

    trie["plum"] = "violet"
    #expect(trie["plum"] == "violet")
    trie["apple"] = "green"
    #expect(trie["apple"] == "green")
}
