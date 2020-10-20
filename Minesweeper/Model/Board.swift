//
//  Board.swift
//  Minesweeper
//
//  Created by Yuanrong Han on 10/19/20.
//  Copyright © 2020 Rex_han. All rights reserved.
//

import SpriteKit

class Board : SKTileMapNode{
    private var numberOfMines : Int!
    private var board : [[Bool]]!
    var minePositions = [CGPoint]()
    var boardNumber : [[Int]]!
    var visitedPosition : [[Bool]]!
    init(tileSet: SKTileSet, columns: Int, rows: Int, tileSize: CGSize, mines: Int) {
        super.init(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        self.name = "Board"
        self.numberOfMines = mines
        self.setupBoard()
        self.generateMines()
        self.setupBoardNumbers()
        self.setupVisited()
        
    }
    
    // MARK: Setups for the board
    private func setupBoard() {
        self.board = [[Bool]](repeating: [Bool](repeating: false, count: self.numberOfColumns), count: self.numberOfRows)
    }
    
    private func setupVisited() {
        self.visitedPosition = [[Bool]](repeating: [Bool](repeating: false, count: self.numberOfColumns), count: self.numberOfRows)
    }
    
    private func generateMines() {
        for _ in 0..<self.numberOfMines {
            self.minePositions.append(CGPoint(x: Int.random(in: 0..<self.numberOfColumns), y: Int.random(in: 0..<self.numberOfRows)))
        }
        // Debug use
//        self.minePositions.append(CGPoint(x: 2, y: 3))
//        self.minePositions.append(CGPoint(x: 4, y: 5))
//        self.minePositions.append(CGPoint(x: 0, y: 0))
//        self.minePositions.append(CGPoint(x: 8, y: 4))
//        self.minePositions.append(CGPoint(x: 9, y: 7))
    }
    
    private func setupBoardNumbers() {
        self.boardNumber = [[Int]](repeating: [Int](repeating: -1, count: self.numberOfColumns), count: self.numberOfRows)
        for i in 0 ..< self.numberOfColumns {
            for j in 0 ..< self.numberOfRows {
                self.boardNumber[i][j] = checkSurroundingMines(of: i, of: j)
            }
        }
    }
    
    private func checkSurroundingMines(of row: Int, of col: Int) -> Int {
        var count = 0
        for i in row - 1 ... row + 1 {
            for j in col - 1 ... col + 1 {
                if i < self.numberOfRows && i >= 0 && j < self.numberOfColumns && j >= 0 {
                    if self.minePositions.contains(CGPoint(x: j, y: i)) {
                        count += 1
                    }
                }
            }
        }
        return count
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
