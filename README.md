# Trie

This Swift package implements prefix and suffix tries. [Tries](https://en.wikipedia.org/wiki/Trie) are particularly well suited for implementing auto-completion.
                                                               
## Examples

Finding fruit names by a prefix:

    let fruits = PrefixTrie("ananas", "apple", "apricot", "orange")
    
    fruits.values(for: "a")    // returns ["ananas", "apple", "apricot"]
    fruits.values(for: "ap")   // returns ["apple", "apricot"]
    fruits.values(for: "app")  // returns ["apple"]
    
Finding any data using prefixes:

    var scores: PrefixTrie<Int> = ["poor": 0, "good": 1, "great": 2, "awesome": 3, "extraordinary": 4]
    
    scores.values(for: "g")    // returns [1, 2]
    scores["fine"]             // is nil
    scores["great"]            // gives 2
    scores["awesome"]          // gives 3
    scores["great"] = 3
    scores["awesome"] = 2
    scores.values(for: "g")    // returns [1, 3]
    
Searching domain names for top level domains is an example for suffix tries:

    let domains: SuffixTrie<String> = [".com", ".co.uk", ".gov.uk", ".gov"]
    
    domains.values(for: ".uk") // returns [".co.uk", ".gov.uk"]
    
## License

Copyright 2025 macoonshine

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
