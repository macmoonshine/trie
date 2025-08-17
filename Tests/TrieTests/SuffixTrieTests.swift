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

let SUFFIX_KEYWORDS = [
    "Any", "as", "associatedtype", "await", "borrowing", "break", "case",
    "catch", "class", "consuming", "continue", "default", "defer", "deinit",
    "do", "else", "enum", "extension", "fallthrough", "false", "fileprivate",
    "for", "func", "guard", "if", "import", "in", "init", "inout", "internal",
    "is", "let", "nil", "nonisolated", "open", "operator", "precedencegroup",
    "private", "protocol", "public", "repeat", "rethrows", "return",
    "self", "Self", "static", "struct", "subscript", "super", "switch", "throw",
    "throws", "true", "try", "typealias", "var", "where", "while"
]

func createSuffixTrie(_ length: Int = SUFFIX_KEYWORDS.count) -> SuffixTrie<String> {
    var trie = SuffixTrie<String>()
    
    for keyword in SUFFIX_KEYWORDS.prefix(length) {
        trie.insert(keyword, keyword)
    }
    return trie
}

@Test func SuffixTrie_values() async throws {
    let trie = createSuffixTrie()
    
    #expect(trie.count == SUFFIX_KEYWORDS.count)
    #expect(trie.values(for: "").sorted() == SUFFIX_KEYWORDS.sorted())
    #expect(trie.values(for: "z") == [])
    #expect(trie.values(for: "k") == ["break"])
    #expect(trie.values(for: "er").sorted() == ["defer", "super"])
    #expect(trie.values(for: "fer") == ["defer"])
    #expect(trie.values(for: "ser") == [])
}

@Test func SuffixTrie_insert() async throws {
    var trie = createSuffixTrie()
    
    #expect(trie.count == SUFFIX_KEYWORDS.count)
    #expect(trie.contains("z") == false)
    #expect(trie.values(for: "z") == [])
    trie.insert("baz", "baz")
    #expect(trie.count == SUFFIX_KEYWORDS.count + 1)
    #expect(!trie.contains("z"))
    #expect(trie.contains(any: "z"))
    #expect(trie.values(for: "z") == ["baz"])
}

@Test func SuffixTrie_remove() async throws {
    var trie = createSuffixTrie()
    
    #expect(trie.count == SUFFIX_KEYWORDS.count)
    #expect(trie.contains("er") == true)
    #expect(trie.values(for: "er").sorted() == ["defer", "super"])
    trie.remove("super")
    #expect(trie.count == SUFFIX_KEYWORDS.count - 1)
    #expect(trie.contains("er") == true)
    #expect(trie.values(for: "er") == ["defer"])
    
    trie = createSuffixTrie()
    
    #expect(trie.contains("defer") == true)
    #expect(trie.values(for: "er").sorted() == ["defer", "super"])
    trie.remove("er")
    #expect(trie.count == SUFFIX_KEYWORDS.count)
    #expect(trie.contains("super") == true)
    #expect(trie.values(for: "er").sorted() == ["defer", "super"])
    trie.remove("super")
    #expect(trie.count == SUFFIX_KEYWORDS.count - 1)
    #expect(trie.contains("super") == false)
    #expect(trie.values(for: "er").sorted() == ["defer"])
    
    trie = createSuffixTrie()
    
    trie.remove(all: "per")
    #expect(trie.count == SUFFIX_KEYWORDS.count - 1)
    #expect(trie.contains("super") == false)
    #expect(trie.values(for: "er").sorted() == ["defer"])
    
    trie.remove(all: "r")
    #expect(trie.count == SUFFIX_KEYWORDS.count - 5)
    #expect(trie.values(for: "a") == [])
}

@Test func SuffixTrie_smallDictionary() async throws {
    let keywords = ["deinit", "init"]
    let trie = SuffixTrie(keywords)
    let dictionary = trie.dictionary()

    #expect(trie.count == keywords.count)
    #expect(dictionary.count == keywords.count)
    #expect(dictionary.keys.sorted() == keywords.sorted())
    for (key, value) in dictionary {
        #expect(keywords.contains(key))
        #expect(key == value)
    }
}

@Test func SuffixTrie_dictionary() async throws {
    let trie = createSuffixTrie()
    let dictionary = trie.dictionary()
    
    #expect(dictionary.count == SUFFIX_KEYWORDS.count)
    #expect(dictionary.keys.sorted() == SUFFIX_KEYWORDS.sorted())
    for (key, value) in dictionary {
        #expect(SUFFIX_KEYWORDS.contains(key))
        #expect(key == value)
    }
}

@Test func SuffixTrie_dictionaryLiteral() async throws {
    let trie: SuffixTrie<String> = ["apple": "red", "banana": "yellow", "orange": "orange"]
    
    #expect(trie.count == 3)
    #expect(trie.values(for: "e").sorted() == ["orange", "red"])
    #expect(trie.values(for: "ge") == ["orange"])
    #expect(trie.values(for: "le") == ["red"])
}

@Test func SuffixTrie_subscript() async throws {
    var trie: SuffixTrie<String> = ["apple": "red", "banana": "yellow", "orange": "orange"]
    
    #expect(trie["apple"] == "red")
    #expect(trie["banana"] == "yellow")
    #expect(trie["orange"] == "orange")
    #expect(trie["e"] == nil)
    
    trie["plum"] = "violet"
    #expect(trie["plum"] == "violet")
    trie["apple"] = "green"
    #expect(trie["apple"] == "green")
}
