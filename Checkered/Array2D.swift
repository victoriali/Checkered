//
//  Array2D.swift
//  Checkered
//
//  Created by Wing Man Li on 12/6/2016.
//  Copyright © 2016 Victoria Li. All rights reserved.
//

import Foundation

struct Array2D<T> {
    let NumColumns: Int
    let NumRows: Int
    private var array: [T]
    
    init(NumColumns col: Int, NumRows row: Int, initialValue: T) {
        NumColumns = col
        NumRows = row
        array = [T](count:row*col, repeatedValue: initialValue)
    }
    
    subscript(column: Int, row: Int) -> T {
        get {
            assert(column >= 0 && column < NumColumns)
            assert(row >= 0 && row < NumRows)
            return array[row*NumColumns + column]
        }
        set {
            assert(column >= 0 && column < NumColumns)
            assert(row >= 0 && row < NumRows)
            array[row*NumColumns + column] = newValue
        }
    }
    
    mutating func setAll(item: T){
        for i in 0..<NumColumns{
            for j in 0..<NumRows {
                self[i,j] = item
            }
        }
    }
}