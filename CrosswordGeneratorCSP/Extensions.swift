//
//  Extensions.swift
//  CrosswordGeneratorCSP
//
//  Created by Deel Usmani on 21/04/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import Foundation

protocol Copyable {
    init(instance: Self)
}

extension Copyable {
    func copy() -> Self {
        return Self.init(instance: self)
    }
}


extension String {
    /// stringToFind must be at least 1 character.
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: .diacriticInsensitive, range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }
}
