//
//  Array2D.swift
//  CrossWordCSP
//
//  Created by Deel Usmani on 16/04/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import Foundation


open class Array2D<T> : Copyable {
    
    open var columns: Int
    open var rows: Int
    open var matrix: [T]
    
    public init(columns: Int, rows: Int, defaultValue: T) {
        self.columns = columns
        self.rows = rows
        matrix = Array(repeating: defaultValue, count: columns * rows)
    }
    
    required public init(instance: Array2D<T>) {
        self.columns = instance.columns
        self.rows = instance.rows
        self.matrix = instance.matrix
    }
    
    open subscript(column: Int, row: Int) -> T {
        get {
            return matrix[columns * row + column]
        }
        set {
            matrix[columns * row + column] = newValue
        }
    }
    
    open func columnCount() -> Int {
        return self.columns
    }
    
    open func rowCount() -> Int {
        return self.rows
    }
}

struct ArraySprite<T> {
    
    let columns: Int
    let rows: Int
    fileprivate var array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count: rows*columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[row*columns + column]
        }
        set {
            array[row*columns + column] = newValue
        }
    }
}
