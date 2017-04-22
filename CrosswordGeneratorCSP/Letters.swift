//
//  Letters.swift
//  CrosswordGeneratorCSP
//
//  Created by Deel Usmani on 21/04/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import Foundation

import SpriteKit

enum LetterType: Int, CustomStringConvertible {
    
    case unknown = 0, croissant
    var spriteName: String {
        let spriteNames = [
            EMPTY_BLOCK
        ]
        
        return spriteNames[rawValue - 1]
    }
    
    var highlightedSpriteName: String {
        return spriteName
    }
    
    static func random() -> LetterType {
        return LetterType(rawValue: 1)! //Int(arc4random_uniform(1)) + 1)!
    }
    
    var description: String {
        return spriteName
    }
}

class Letter : CustomStringConvertible, Hashable {
    
    var column: Int
    var row: Int
    let letterType: LetterType
    var sprite: SKSpriteNode?
    
    init(column: Int, row: Int, letterType: LetterType) {
        self.column = column
        self.row = row
        self.letterType = letterType
    }
    
    var description: String {
        return "type:\(letterType) square:(\(column),\(row))"
    }
    
    var hashValue: Int {
        return row*10 + column
    }
}

func ==(lhs: Letter, rhs: Letter) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
