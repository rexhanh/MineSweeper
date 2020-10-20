//
//  Gridgroup.swift
//  Minesweeper
//
//  Created by Yuanrong Han on 10/20/20.
//  Copyright © 2020 Rex_han. All rights reserved.
//

import SpriteKit

enum gridtype {
    case grid, revealgrid, minefail, one, two, three
}


class GridGroup {
    
    private var tileGroups = [SKTileGroup]()
    private var tileset : SKTileSet!
    var gridSize : CGSize = CGSize(width: 16, height: 16)
    let scale : CGFloat = 2
    init() {
        setupGridTiles()
    }
    // MARK: Setups for the groups and tiles
    private func setupGridTiles() {
        let gridTexture = SKTexture(imageNamed: "grid")
        let gridDefinition = SKTileDefinition(texture: gridTexture, size: gridTexture.size())
        let gridGroup = SKTileGroup(tileDefinition: gridDefinition)
        self.tileGroups.append(gridGroup)
        
        let revealgridTexture = SKTexture(imageNamed: "grid_revealed")
        let revealgridDefinition = SKTileDefinition(texture: revealgridTexture, size: gridTexture.size())
        let revealgridGroup = SKTileGroup(tileDefinition: revealgridDefinition)
        self.tileGroups.append(revealgridGroup)
        
        let mineFailTexture = SKTexture(imageNamed: "mine_0")
        let mineFailDefinition = SKTileDefinition(texture: mineFailTexture, size: gridTexture.size())
        let mineFailGroup = SKTileGroup(tileDefinition: mineFailDefinition)
        self.tileGroups.append(mineFailGroup)
        
        let oneTexture = SKTexture(imageNamed: "one")
        let oneDefinition = SKTileDefinition(texture: oneTexture, size: gridTexture.size())
        let oneGroup = SKTileGroup(tileDefinition: oneDefinition)
        self.tileGroups.append(oneGroup)
        
        let twoTexture = SKTexture(imageNamed: "two")
        let twoDefinition = SKTileDefinition(texture: twoTexture, size: gridTexture.size())
        let twoGroup = SKTileGroup(tileDefinition: twoDefinition)
        self.tileGroups.append(twoGroup)
        
        let threeTexture = SKTexture(imageNamed: "three")
        let threeDefinition = SKTileDefinition(texture: threeTexture, size: gridTexture.size())
        let threeGroup = SKTileGroup(tileDefinition: threeDefinition)
        self.tileGroups.append(threeGroup)
        
        let gridTileset = SKTileSet(tileGroups: self.tileGroups)
        self.tileset = gridTileset
    }
    
    // MARK: Get functions
    func gettilegroup(of tile: gridtype) -> SKTileGroup {
        var tilegroup : SKTileGroup!
        switch tile {
        case .revealgrid:
            tilegroup = self.tileGroups[1]
        case .minefail:
            tilegroup = self.tileGroups[2]
        case .one:
            tilegroup = self.tileGroups[3]
        case .two:
            tilegroup = self.tileGroups[4]
        case .three:
            tilegroup = self.tileGroups[5]
        default:
            tilegroup = self.tileGroups[0]
        }
        return tilegroup
    }
    
    func getTileSet() -> SKTileSet {
        return self.tileset
    }
}
