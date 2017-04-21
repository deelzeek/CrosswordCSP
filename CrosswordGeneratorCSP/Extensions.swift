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
