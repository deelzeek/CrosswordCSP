//
//  Level.swift
//  Cookie
//
//  Created by Deel Usmani on 16/04/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import Foundation


let NumColumns = 30
let NumRows = 28

class Level {
    fileprivate var letters = ArraySprite<Letter>(columns: NumColumns, rows: NumRows)
    
    
    func letterAt(column: Int, row: Int) -> Letter? {
        assert(column >= 0 && column < NumColumns)
        assert(row >= 0 && row < NumRows)
        return letters[column, row]
    }
    
    func shuffle() -> Set<Letter> {
        return createInitialLetters()
    }
    
    private func createInitialLetters() -> Set<Letter> {
        var set = Set<Letter>()
        
        // 1
        for row in 0..<NumRows {
            for column in 0..<NumColumns {
                
                // 2
                var letterType = LetterType.random()
                
                // 3
                let letter = Letter(column: column, row: row, letterType: letterType)
                letters[column, row] = letter
                
                // 4
                set.insert(letter)
            }
        }
        return set
    }
}


