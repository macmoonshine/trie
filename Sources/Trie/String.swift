//
// Copyright 2025 macoonshine
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
//

extension StringProtocol {
    func suffix(at length: Int) -> Self.SubSequence? {
        if length > count {
            return nil
        }
        else {
            let index = index(startIndex, offsetBy: length)
            return suffix(from: index)
        }
    }
    
    func prefix<S>(common string: S) -> SubSequence where S: StringProtocol {
        var i1 = startIndex
        var i2 = string.startIndex
        
        while i1 < endIndex && i2 < string.endIndex && self[i1] == string[i2] {
            i1 = index(after: i1)
            i2 = string.index(after: i2)
        }
        return self[..<i1]
    }
    
    func length<S>(common string: S) -> Int where S: StringProtocol {
        var i1 = startIndex
        var i2 = string.startIndex
        var count = 0
        
        while i1 < endIndex && i2 < string.endIndex && self[i1] == string[i2] {
            count += 1
            i1 = index(after: i1)
            i2 = string.index(after: i2)
        }
        return count
    }
}

extension StringProtocol {
    var reversedString: String {
        String(reversed())
    }
}
