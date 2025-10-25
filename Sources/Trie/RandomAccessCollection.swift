//
//  RandomAccessCollection.swift
//  Trie
//
//  Created by Clemens Wagner on 25.10.25.
//

public extension RandomAccessCollection {
    /// Bisect search algorithm adapted from: https://stackoverflow.com/a/35206907/2352344
    func bisectFirstIndex(where predicate: (Element) throws -> Bool) rethrows -> Index? {
        var start = startIndex
        var end = endIndex
        
        while start != end {
            let length = distance(from: start, to: end)
            guard length > 1 else {
                return try predicate(self[start]) ? start : nil
            }
            let mid = index(start, offsetBy: (length - 1) / 2)
            
            if try predicate(self[mid]) {
                end = index(after: mid)
            }
            else {
                start = index(after: mid)
            }
        }
        return nil
    }
}

