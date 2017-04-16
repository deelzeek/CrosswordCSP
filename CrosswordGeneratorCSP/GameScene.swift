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
    let cookiesLayer = SKNode()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        
        addChild(gameLayer)
        
        let layerPosition = CGPoint(
            x: -TileWidth * CGFloat(NumColumns) / 2,
            y: -TileHeight * CGFloat(NumRows) / 2)
        
        cookiesLayer.position = layerPosition
        gameLayer.addChild(cookiesLayer)
    }
    
    func addSprites(for cookies: Set<Cookie>) {
        for cookie in cookies {
            let sprite = SKSpriteNode(imageNamed: cookie.cookieType.spriteName)
            sprite.size = CGSize(width: TileWidth, height: TileHeight)
            sprite.position = pointFor(column: cookie.column, row: cookie.row)
            cookiesLayer.addChild(sprite)
            cookie.sprite = sprite
        }
    }
    
    func pointFor(column: Int, row: Int) -> CGPoint {
        return CGPoint(
            x: CGFloat(column)*TileWidth + TileWidth/2,
            y: CGFloat(row)*TileHeight + TileHeight/2)
    }
    
    public func drawCrossword(print: Array<Array<String>>) {
        
        self.cookiesLayer.removeAllChildren()
        
        for row in 0..<print.count {
            
            for column in 0..<print[0].count {
                
                let item = print[row][column]
                         
                if item == "-" {
                    let sprite = SKSpriteNode(imageNamed: "blackblock")
                    sprite.size = CGSize(width: TileWidth, height: TileHeight)
                    sprite.position = pointFor(column: column, row: print.count - row)
                    self.cookiesLayer.addChild(sprite)
                } else {
                    let sprite = SKSpriteNode(imageNamed: item.capitalized)
                    sprite.size = CGSize(width: TileWidth, height: TileHeight)
                    sprite.position = pointFor(column: column, row: print.count - row)
                    self.cookiesLayer.addChild(sprite)
                }
                
            }
        }
    }
    
   

}
