//
//  GameScene.swift
//  CrosswordGeneratorCSP
//
//  Created by Deel Usmani on 16/04/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation

class GameScene: SKScene {
    var level: Level!
    
    let TileWidth: CGFloat = 10.5
    let TileHeight: CGFloat = 11.5
    
    let gameLayer = SKNode()
    let lettersLayer = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(INIT_NOT_USED)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(COLUMNS) / 2,
            y: -TileHeight * CGFloat(ROWS) / 2)
        
        lettersLayer.position = layerPosition
        gameLayer.addChild(lettersLayer)
    }
    
    func addSprites(for letters: Set<Letter>) {
        for letter in letters {
            let sprite = SKSpriteNode(imageNamed: letter.letterType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(column: letter.column, row: letter.row)
            lettersLayer.addChild(sprite)
            letter.sprite = sprite
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    public func drawCrossword(print: Array<Array<String>>) {
        
        self.lettersLayer.removeAllChildren()
        
        for row in 0..<print.count {
            
            for column in 0..<print[0].count {
                
                let item = print[row][column]
                         
                if item == "-" {
                    let sprite = SKSpriteNode(imageNamed: EMPTY_BLOCK)
                    sprite.size = CGSize(width: TileWidth, height: TileHeight)
                    sprite.position = pointFor(column: column, row: print.count - row)
                    self.lettersLayer.addChild(sprite)
                } else {
                    let sprite = SKSpriteNode(imageNamed: item.capitalized)
                    sprite.size = CGSize(width: TileWidth, height: TileHeight)
                    sprite.position = pointFor(column: column, row: print.count - row)
                    self.lettersLayer.addChild(sprite)
                }
                
            }
        }
    }
    
   

}
