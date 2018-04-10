//
//  MozaicGenerator.swift
//  CrosswordGeneratorCSP
//
//  Created by Plov Lover on 09/04/2018.
//  Copyright © 2018 Deel Usmani. All rights reserved.
//

import UIKit

open class MozaicGenerator {
    
    // MARK: - Additional types
    
    public struct Word {
        public var word = ""
        public var column = 0
        public var row = 0
        public var direction: WordDirection = .vertical
    }
    
    public enum WordDirection {
        case vertical
        case horizontal
    }
    
    // MARK: - Public properties
    
    open var columns: Int = 0
    open var rows: Int = 0
    open var maxLoops: Int = 2000
    open var words: Array<String> = Array()
    
    open var result: Array<Word> {
        get {
            return resultData
        }
    }
    
    open var currentPrintable: Array<Array<String>> {
        get {
            return self.arrayPrint()
        }
    }
    
    open var chosenWords: Array<String> {
        get {
            return self.currentWords
        }
    }
    
    
    // MARK: - Public additional properties
    
    open var fillAllWords = false
    open var occupyPlaces = false
    open var emptySymbol = SYMBOL_EMPTY_GRID
    open var debug = true
    open var orientationOptimization = false
    open var occupiedPlaces: Array2D<Int>?
    var primary = true
    
    open let NOT_OCCUPIED = 0
    open let ALREADY_OCCUPIED = 1
    
    open var amountOfWordsToFit = 0
    
    // MARK: - Logic properties
    
    fileprivate var grid: Array2D<String>?
    fileprivate var currentWords: Array<String> = Array()
    fileprivate var resultData: Array<Word> = Array()
    
    // MARK: - Initialization
    
    public init() {}
    
    public init(columns: Int, rows: Int, maxLoops: Int = 2000, words: Array<String>) {
        self.columns = columns
        self.rows = rows
        self.maxLoops = maxLoops
        self.words = words
    }
    
    //###################################################
    //
    // MARK: - Mozaic generation
    //
    //###################################################
    
    func generateMozaic() {
        
        self.grid = nil
        self.grid = Array2D(columns: columns, rows: rows, defaultValue: emptySymbol)
        
        currentWords.removeAll()
        resultData.removeAll()
        words.shuffle()
        
        var allCellCount = columns * rows
        
        if debug {
            debugPrint(HEADER_WORDS)
            debugPrint(words)
        }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        var currentColumn = 0
        var currentRow = 0
        var error = 0
        var shouldRefresh = false
        
        while allCellCount != 0 {
            
            // if the same mistake was repeated 10 times then fail
            // refresh all data and try again
            if error == 10 {
                // Refresh
                debugPrint("********* Could not fit ***********")
                shouldRefresh = true
            }
            
            if shouldRefresh {
                self.grid = nil
                self.grid = Array2D(columns: columns, rows: rows, defaultValue: emptySymbol)
                resultData.removeAll()
                
                allCellCount = columns * rows
                error = 0
                currentColumn = 0
                currentRow = 0

                shouldRefresh = false
            }
            
            // get random letter
            let letter = randomLetter()
            
            if canFitHere(col: currentColumn, row: currentRow, letter: letter) {
                
                // Set letter
                setCell(currentColumn, row: currentRow, value: letter)
                
                allCellCount -= 1
                
                // Config location
                if currentRow != rows - 1 {
                    currentRow += 1
                } else {
                    if currentColumn != columns - 1 {
                        currentColumn += 1
                        currentRow = 0
                    }
                }
                
                // Empty error collection if it has found a correct way
                if error > 0 {
                    error = 0
                }
                
                // Print data
                debugPrint(HEADER_LOOP)
                self.printGrid()
                
                // If done
                if allCellCount == 0 {
                    if areRowsUnique() && areColumnsUnique() {
                        debugPrint("Success! Rows and cols are unique!")
                    } else {
                        debugPrint("Rows and/or cols are not unique")
                        allCellCount += 1
                        shouldRefresh = true
                    }
                }
                
            } else {
                error += 1
            }
        }

        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        debugPrint("Time elapsed for brute force: \(Double(timeElapsed)) s")
        
        if debug {
            debugPrint(HEADER_RESULT)
            printGrid()
        }
    }
    
    private func randomLetter() -> String {
        return self.words[randomInt(0, max: self.words.count - 1)]
    }
    
    // Check if letter can fit at this loc
    
    private func canFitHere(col: Int, row: Int, letter: String) -> Bool {

        // Check cols
        
        if col >= 2 && col <= (columns - 3) {
            if (getCell(col - 1, row: row) == letter && getCell(col - 2, row: row) == letter) || (getCell(col + 1, row: row) == letter && getCell(col + 2, row: row) == letter) {
                return false
            }
        } else if col == (columns - 2) {
            if (getCell(col - 1, row: row) == letter && getCell(col - 2, row: row) == letter) || (getCell(col - 1, row: row) == letter && getCell(col + 1, row: row) == letter) {
                return false
            }
        } else if col == (columns - 1) {
            if (getCell(col - 1, row: row) == letter && getCell(col - 2, row: row) == letter) {
                return false
            }
        } else if col == 1 {
            if (getCell(col - 1, row: row) == letter && getCell(col + 1, row: row) == letter) {
                return false
            }
        }
        
        // Check rows
        
        if row >= 2  && row <= (rows - 3) {
            if (getCell(col, row: row - 1) == letter && getCell(col, row: row - 2) == letter) || (getCell(col, row: row + 1) == letter && getCell(col, row: row + 2) == letter) {
                return false
            }
        } else if row == (rows - 2) {
            if (getCell(col, row: row - 1) == letter && getCell(col, row: row - 2) == letter) || (getCell(col, row: row - 1) == letter && getCell(col, row: row + 1) == letter) {
                return false
            }
        } else if row == (rows - 1) {
            if (getCell(col, row: row - 1) == letter && getCell(col, row: row - 2) == letter) {
                return false
            }
        } else if row == 1 {
            if (getCell(col, row: row - 1) == letter && getCell(col, row: row + 1) == letter) {
                return false
            }
        }
        
        return true
    }
    
    // Check if rows are uniq
    private func areRowsUnique() -> Bool {
        
        var allRows = [String]()
        for i in 0..<rows {
            var row = String()
            for n in 0..<columns {
                row += getCell(n, row: i)
            }
            
            if !allRows.contains(row) {
                allRows.append(row)
            } else {
                let rowNum = allRows.index(of: row)
                debugPrint("Row: \(i) exists at row: \(rowNum.debugDescription)")
                return false
            }
        }
        
        return true
    }
    
    // Check if cols are uniq
    
    private func areColumnsUnique() -> Bool {
        
        var allColumns = [String]()
        for i in 0..<columns {
            var col = String()
            for n in 0..<rows {
                col += getCell(i, row: n)
            }
            
            if !allColumns.contains(col) {
                allColumns.append(col)
            } else {
                let colNum = allColumns.index(of: col)
                debugPrint("Col: \(i) exists at col: \(colNum.debugDescription)")
                return false
            }
        }
        
        return true
    }
    
    //###################################################
    //
    // MARK: - Backtracking method
    //
    //###################################################
    
    open func generateWithBacktrack() {
        self.grid = nil
        self.grid = Array2D(columns: columns, rows: rows, defaultValue: emptySymbol)
        
        self.occupiedPlaces = nil
        self.occupiedPlaces = Array2D(columns: columns, rows: rows, defaultValue: NOT_OCCUPIED)
        
        currentWords.removeAll()
        resultData.removeAll()
        
        if debug {
            debugPrint(HEADER_WORDS)
            debugPrint(words)
        }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        _ = backtrackMozaic(col: 0, row: 0, depth: 0)
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("Time elapsed for backtracking: \(Double(timeElapsed)) s")
        
        if debug {
            debugPrint(HEADER_RESULT)
            printGrid()
        }
        
    }
    
    private func backtrackMozaic(col: Int, row: Int, depth: Int) -> Bool {
        // All cells are filled
        if currentWords.count == (columns * rows) {
            return true
        }
        
        for letter in words {
            if (self.canFitHere(col: col, row: row, letter: letter)) {
                // Set letter
                self.setCell(col, row: row, value: letter)
                self.currentWords.append(letter)
                
                // Print
                if debug {
                    printGrid()
                    debugPrint("depth: \(depth), col: \(col), row: \(row)")
                }
                
                // Carry on searching
                if (row == (rows - 1)) && (col < (columns - 1)) {
                    if backtrackMozaic(col: col + 1, row: 0, depth: depth + 1) {
                        return true
                    }
                } else if (row < (rows - 1) && (col < (columns - 1))) {
                    if backtrackMozaic(col: col, row: row + 1, depth: depth + 1) {
                        return true
                    }
                } else if (col == (columns - 1) && (row <= (rows - 1))) {
                    if backtrackMozaic(col: col, row: row + 1, depth: depth + 1) {
                        return true
                    }
                }
            }
        }
        
        currentWords.removeLast()
        removeLastWord()
        return false
    }
    
    //###################################################
    //
    // MARK: - Forward checking method
    //
    //###################################################
    
    open func generateWithForwardChecking() {
        self.grid = nil
        self.grid = Array2D(columns: columns, rows: rows, defaultValue: emptySymbol)
        
        currentWords.removeAll()
        resultData.removeAll()
        
        if debug {
            debugPrint(HEADER_WORDS)
            debugPrint(words)
        }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        //-------
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        debugPrint("Time elapsed for forwardchecking: \(Double(timeElapsed)) s")
        
        
    }
    
    private func forwardChecking(_ next: Array<String>,_ grid: Array2D<String>,_ deepness: Int) -> Bool {
        return true
    }
    
    // MARK: - Utils
    
    func setCell(_ column: Int, row: Int, value: String) {
        grid![column, row] = value
        // NEW BELOW
        var word = Word()
        word.word = value
        word.column = column
        word.row = row
        resultData.append(word)
    }
    
    func getCell(_ column: Int, row: Int) -> String {
        return grid![column, row]
    }
    
    func checkIfCellClear(_ column: Int, row: Int) -> Bool {
        if column > 0 && row > 0 && column < columns && row < rows {
            return getCell(column, row: row) == emptySymbol ? true : false
        }
        else {
            return true
        }
    }
    
    fileprivate func setWord(_ column: Int, row: Int, direction: Int, word: String, force: Bool = false) {
        
        if force {
            
            let w = Word(word: word, column: column, row: row, direction: (direction == 0 ? .horizontal : .vertical))
            // WARNING:
            resultData.append(w)
            
            currentWords.append(word)
            
            var c = column
            var r = row
            
            for letter in word.characters {
                setCell(c, row: r, value: String(letter))
                if occupyPlaces {
                    self.occupiedPlaces![c,r] = self.occupiedPlaces![c,r] + ALREADY_OCCUPIED
                }
                
                if direction == 0 {
                    c += 1
                }
                else {
                    r += 1
                }
            }
            
        }
    }
    
    private func removeLastWord() {
        
        //printOccupiedGrid()
        
        guard let last = self.resultData.last else {
            return
        }
        
        var c = last.column
        var r = last.row
        var direction = last.direction
        
        //print("REMOVE WORD")
        
        for _ in last.word.characters {
            
            if self.occupiedPlaces![c,r] > NOT_OCCUPIED {
                self.occupiedPlaces![c,r] = self.occupiedPlaces![c,r] - ALREADY_OCCUPIED
            } else if self.occupiedPlaces![c,r] == NOT_OCCUPIED {
                continue
            }
            setCell(c, row: r, value: emptySymbol)
            if direction == .horizontal {
                c += 1
            }
            else {
                r += 1
            }
            
            printGrid()
            
        }
        
        self.resultData.removeLast()
        
    }
    
    // MARK: - Misc
    
    fileprivate func randomValue() -> Int {
        if orientationOptimization {
            return UIDevice.current.orientation.isLandscape ? 1 : 0
        }
        else {
            return randomInt(0, max: 1)
        }
    }
    
    fileprivate func randomInt(_ min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    // MARK: - Debug
    
    func printGrid() {
        
        for i in 0 ..< rows {
            var s = ""
            for j in 0 ..< columns {
                s += grid![j, i]
            }
            debugPrint(s)
        }
        
    }
    
    func printOccupiedGrid() {
        for i in 0 ..< rows {
            var s = ""
            for j in 0 ..< columns {
                s += "\(occupiedPlaces![j, i])"
            }
            debugPrint(s)
        }
    }
    
    func arrayPrint() -> Array<Array<String>> {
        
        var crossword = Array<Array<String>>()
        
        for i in 0..<rows {
            var arr = Array<String>()
            for j in 0 ..< columns {
                arr.append(grid![j, i])
            }
            crossword.append(arr)
        }
        
        
        return crossword
    }
    
    
    
    
}
