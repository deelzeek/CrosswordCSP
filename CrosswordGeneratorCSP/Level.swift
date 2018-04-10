//
//  Level.swift
//  Cookie
//
//  Created by Deel Usmani on 16/04/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import Foundation

//let NumColumns = 30
//let NumRows = 28

class Level {
    fileprivate var letters = ArraySprite<Letter>(columns: COLUMNS, rows: ROWS)
    
    func letterAt(column: Int, row: Int) -> Letter? {
        assert(column >= 0 && column < COLUMNS)
        assert(row >= 0 && row < ROWS)
        return letters[column, row]
    }
    
    func shuffle() -> Set<Letter> {
        return createInitialLetters()
    }
    
    private func createInitialLetters() -> Set<Letter> {
        var set = Set<Letter>()
        
        for row in 0..<ROWS {
            for column in 0..<COLUMNS {
                
                var letterType = LetterType.random()
                
                let letter = Letter(column: column, row: row, letterType: letterType)
                letters[column, row] = letter
                
                set.insert(letter)
            }
        }
        return set
    }
}


