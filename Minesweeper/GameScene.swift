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
    
    private var isTouched : Bool = false
    private var initialTouchTime : TimeInterval!
    private var touchduration : TimeInterval!
    
    private var touchedGrid : (Int, Int)!
    
    override func didMove(to view: SKView) {
        setupBoard(10, 10)
        self.scale = gridgroup.scale
        
        let longgesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        
        longgesture.minimumPressDuration = 0.01
        
        self.view!.addGestureRecognizer(longgesture)
    }
    
    @objc func longPressed(sender: UIGestureRecognizer) {
        var touchLocation = sender.location(in: sender.view)
        touchLocation = self.convertPoint(fromView: touchLocation)
        let touchgrid = getgridfromtouch(touchlocation: touchLocation)
        
        if (sender.state == UIGestureRecognizer.State.ended) {
            let currentTouchGrid = getgridfromtouch(touchlocation: touchLocation)
            if self.touchedGrid != currentTouchGrid {
                self.reset(touchlocation: self.touchedGrid)
            } else {
                self.reset(touchlocation: touchgrid)
                self.reveal(touchlocation: self.touchedGrid)
            }
            
        } else if (sender.state == UIGestureRecognizer.State.cancelled) {
            let currentTouchGrid = getgridfromtouch(touchlocation: touchLocation)
            if self.touchedGrid != currentTouchGrid {
                self.reset(touchlocation: self.touchedGrid)
            } else {
                self.reset(touchlocation: touchgrid)
            }
            
        } else if (sender.state == UIGestureRecognizer.State.began) {
            self.touchedGrid = getgridfromtouch(touchlocation: touchLocation)
            self.initialreveal(touchlocation: touchgrid)
        }
    }
    
    private func getgridfromtouch(touchlocation: CGPoint) -> (Int, Int) {
        let touchNode = atPoint(touchlocation)
        if touchNode.name == "Board" {
            guard let grid = touchNode as? SKTileMapNode else {return (-1, -1)}
            var l = touchlocation
            l.x = l.x / self.scale
            l.y = l.y / self.scale
            let col = grid.tileColumnIndex(fromPosition: l)
            let row = grid.tileRowIndex(fromPosition: l)
            return (col, row)
        }
        return (-1, -1)
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
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isTouched = true
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isTouched = false
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.isTouched = false
    }
    
//    private func handleReveal(_ touches: Set<UITouch>) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            let touchNode = atPoint(location)
//            if touchNode.name == "Board" {
//                guard let grid = touchNode as? SKTileMapNode else {return}
//                var l = location
//                l.x = l.x / self.scale
//                l.y = l.y / self.scale
//                let col = grid.tileColumnIndex(fromPosition: l)
//                let row = grid.tileRowIndex(fromPosition: l)
//                // For debugging
////                reveal(forrow: row, forcol: col)
//                revealGrid(at: row, at: col)
//            }
//        }
//    }
    
//    private func handleinitialreveal(_ touches: Set<UITouch>) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            let touchNode = atPoint(location)
//            if touchNode.name == "Board" {
//                guard let grid = touchNode as? SKTileMapNode else {return}
//                var l = location
//                l.x = l.x / self.scale
//                l.y = l.y / self.scale
//                let col = grid.tileColumnIndex(fromPosition: l)
//                let row = grid.tileRowIndex(fromPosition: l)
//                if !self.board.visitedPosition[col][row] {
//                    self.board.setTileGroup(self.gridgroup.gettilegroup(of: .revealgrid), forColumn: col, row: row)
//                }
//            }
//        }
//    }
    
//    private func resettile(_ touches: Set<UITouch>) {
//        for touch in touches {
//            let location = touch.location(in: self)
//            let touchNode = atPoint(location)
//            if touchNode.name == "Board" {
//                guard let grid = touchNode as? SKTileMapNode else {return}
//                var l = location
//                l.x = l.x / self.scale
//                l.y = l.y / self.scale
//                let col = grid.tileColumnIndex(fromPosition: l)
//                let row = grid.tileRowIndex(fromPosition: l)
//                if !self.board.visitedPosition[col][row] {
//                    self.board.setTileGroup(self.gridgroup.gettilegroup(of: .grid), forColumn: col, row: row)
//                }
//            }
//        }
//    }
    // MARK: Handles Touch Reveal
    private func initialreveal(touchlocation: (Int, Int)) {
        let col = touchlocation.0
        let row = touchlocation.1
        if touchlocation != (-1, -1) {
            if !self.board.visitedPosition[col][row] {
                self.board.setTileGroup(self.gridgroup.gettilegroup(of: .revealgrid), forColumn: col, row: row)
            }
        }
    }
    
    private func reset(touchlocation: (Int, Int)) {
        let col = touchlocation.0
        let row = touchlocation.1
        if touchlocation != (-1, -1) {
            if !self.board.visitedPosition[col][row] {
                self.board.setTileGroup(self.gridgroup.gettilegroup(of: .grid), forColumn: col, row: row)
            }
        }

    }
    
    private func reveal(touchlocation: (Int, Int)) {
        let col = touchlocation.0
        let row = touchlocation.1
        if touchlocation != (-1, -1) {
            print("Reveal started")
            self.revealGrid(at: row, at: col)
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
            revealGrid(at: row + 1, at: col + 1)
            revealGrid(at: row + 1, at: col - 1)
            revealGrid(at: row - 1, at: col + 1)
            revealGrid(at: row - 1, at: col - 1)
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
    

    override func update(_ currentTime: TimeInterval) {
        if self.isTouched {
            self.initialTouchTime = currentTime
        } else {
            if (self.initialTouchTime != nil) {
                self.touchduration = currentTime - self.initialTouchTime
            }
        }
    }
}
