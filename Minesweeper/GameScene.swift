//
//  GameScene.swift
//  Minesweeper
//
//  Created by Yuanrong Han on 10/18/20.
//  Copyright © 2020 Rex_han. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    private let gridgroup = GridGroup()
    private var scale : CGFloat!
    var board : Board!
    var isLongPressing = false

    override func didMove(to view: SKView) {
        setupBoard(10, 10)
        self.scale = gridgroup.scale
        
        let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(longPress:)))

        gesture.minimumPressDuration = 0.5

        self.view!.addGestureRecognizer(gesture)
    }
    
    @objc func longPressed(longPress: UIGestureRecognizer) {

        if (longPress.state == UIGestureRecognizer.State.ended) {
            self.isLongPressing = false
        }else if (longPress.state == UIGestureRecognizer.State.began) {
            var l = longPress.location(in: self.view!)
            l.x = l.x / self.scale
            l.y = l.y / self.scale
            let col = self.board.tileColumnIndex(fromPosition: l)
            let row = self.board.tileRowIndex(fromPosition: l)
            print("Col \(col), row \(row)")
        }
        
    }
    
    
    private func setupBoard(_ rows: Int, _ cols: Int) -> Void {
        let board = Board(tileSet: self.gridgroup.getTileSet(), columns: cols, rows: rows, tileSize: self.gridgroup.gridSize, mines: 10)
        board.name = "Board"
        board.position = CGPoint(x:0, y: 0)
        board.setScale(self.gridgroup.scale)
        for i in 0 ..< cols {
            for j in 0 ..< rows {
                board.setTileGroup(self.gridgroup.gettilegroup(of: .grid), forColumn: i, row: j)
            }
        }

        self.board = board
        self.addChild(self.board)
    }
    
    private func reveal(forrow row: Int, forcol col: Int) {
        if self.board.minePositions.contains(CGPoint(x: col, y: row)) {
            self.board.setTileGroup(self.gridgroup.gettilegroup(of: .minefail), forColumn: col, row: row)
        } else {
            self.board.setTileGroup(self.gridgroup.gettilegroup(of: .revealgrid), forColumn: col, row: row)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isLongPressing {
            handleReveal(touches)
        }
    }
    
    // MARK: Handles Touch Reveal
    private func handleReveal(_ touches: Set<UITouch>) {
        for touch in touches {
            let location = touch.location(in: self)
            print("Touch location is \(location)")
            let touchNode = atPoint(location)
            if touchNode.name == "Board" {
                guard let grid = touchNode as? SKTileMapNode else {return}
                var l = location
                l.x = l.x / self.scale
                l.y = l.y / self.scale
                let col = grid.tileColumnIndex(fromPosition: l)
                let row = grid.tileRowIndex(fromPosition: l)
                // For debugging
//                reveal(forrow: row, forcol: col)
                revealGrid(at: row, at: col)
            }
        }
    }
    
    // MARK: Search for the grid to be reavealed
    
    private func revealGrid(at row: Int, at col: Int) {
        if row < 0 || row >= self.board.numberOfRows || col < 0 || col >= self.board.numberOfColumns || self.board.visitedPosition[col][row]{
            return
        } else if self.board.minePositions.contains(CGPoint(x: col, y: row)) {
            self.board.visitedPosition[col][row] = true
            self.board.setTileGroup(self.gridgroup.gettilegroup(of: .minefail), forColumn: col, row: row)
        } else if self.board.boardNumber[row][col] == 0 {
            self.board.visitedPosition[col][row] = true
            self.board.setTileGroup(self.gridgroup.gettilegroup(of: .revealgrid), forColumn: col, row: row)
            revealGrid(at: row + 1, at: col)
            revealGrid(at: row - 1, at: col)
            revealGrid(at: row, at: col - 1)
            revealGrid(at: row, at: col + 1)
        } else if self.board.boardNumber[row][col] != 0{
            self.board.visitedPosition[col][row] = true
            let number = self.board.boardNumber[row][col]
            settilehelper(col: col, row: row, number: number)
        }
    }
    
    private func settilehelper(col: Int, row: Int, number : Int) {
        var group : SKTileGroup!
        switch number {
        case 2:
            group = self.gridgroup.gettilegroup(of: .two)
        case 3:
            group = self.gridgroup.gettilegroup(of: .three)
        default:
            group = self.gridgroup.gettilegroup(of: .one)
        }
        self.board.setTileGroup(group, forColumn: col, row: row)
    }
    
}
