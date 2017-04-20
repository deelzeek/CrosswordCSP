//
//  GameViewController.swift
//  CrosswordGeneratorCSP
//
//  Created by Deel Usmani on 16/04/2017.
//  Copyright © 2017 Deel Usmani. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet var crosswordView: SKView!
    @IBOutlet var wordsView: UITextView!
    @IBOutlet var createCross: UIButton!
    @IBOutlet var btBacktrack: UIButton!
    @IBOutlet var btForwardtrack: UIButton!
    
    var scene: GameScene!
    var level: Level!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = crosswordView as! SKView
        skView.isMultipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.backgroundColor = UIColor.white
        scene.scaleMode = .aspectFill
        
        level = Level()
        scene.level = level
        
        // Present the scene.
        skView.presentScene(scene)
        
        beginGame()
    }
    
    func beginGame() {
        shuffle()
    }
    
    func shuffle() {
        let newCookies = level.shuffle()
        scene.addSprites(for: newCookies)
    }

    @IBAction func onCreateCross(_ sender: Any) {
        let queue = DispatchQueue(label: "uz.plovlover.crossword")
        
        queue.async {
            let crosswordsGenerator = CrosswordsGenerator()
            crosswordsGenerator.words = ["saffron", "pumpernickel", "leaven", "coda", "paladin", "syncopation", "albatross", "harp", "piston", "caramel", "coral", "dawn", "pitch", "fjord", "lip", "lime", "mist", "plague", "yarn", "snicker", "pidar", "zaibal", "doxuya", "govorish", "yeblan", "chmoshnik"]
            crosswordsGenerator.columns = 30
            crosswordsGenerator.rows = 28
            
            crosswordsGenerator.bruteForce = true
            crosswordsGenerator.debug = false
            //crosswordsGenerator.fillAllWords = true
            
            var bestResult: Array = Array<Any>()
            var printable = Array<Array<String>>()
            let attempts = 10
            
            for _ in 0...attempts {
                crosswordsGenerator.generate()
                let result = crosswordsGenerator.result
                
                if result.count > bestResult.count {
                    bestResult.removeAll()
                    for word in result {
                        bestResult.append(word)
                    }
                    
                    printable = crosswordsGenerator.currentPrintable
                }
                
            }
            print("br: \(bestResult.count), words: \(crosswordsGenerator.words.count)")

            DispatchQueue.main.async {
              self.scene.drawCrossword(print: printable)  
            }

        }
        
    }
    
    @IBAction func onBacktrackAction(_ sender: Any) {
        let queue = DispatchQueue(label: "uz.plovlover.crossword")
        
        queue.async {
            let crosswordsGenerator = CrosswordsGenerator()
            crosswordsGenerator.words = ["saffron", "pumpernickel", "leaven", "coda", "paladin", "syncopation", "albatross", "harp", "piston", "caramel", "coral", "dawn", "pitch", "fjord", "lip", "lime", "mist", "plague", "yarn", "snicker", "pidar", "zaibal", "doxuya", "govorish", "yeblan", "chmoshnik"]
            crosswordsGenerator.columns = 30
            crosswordsGenerator.rows = 28
            
            crosswordsGenerator.debug = false
            //crosswordsGenerator.fillAllWords = true
            
            var bestResult: Array = Array<Any>()
            var printable = Array<Array<String>>()
            let attempts = 1
            
            for _ in 0...attempts {
                crosswordsGenerator.generateWithBacktrack()
                let result = crosswordsGenerator.result
                
                if result.count > bestResult.count {
                    bestResult.removeAll()
                    for word in result {
                        bestResult.append(word)
                    }
                    
                    printable = crosswordsGenerator.currentPrintable
                }
                
            }
            print("br: \(bestResult.count), words: \(crosswordsGenerator.words.count)")
            
            DispatchQueue.main.async {
                self.scene.drawCrossword(print: printable)
            }
            
        }

    }
    
    
    @IBAction func onForwardtreackAction(_ sender: Any) {
        let queue = DispatchQueue(label: "uz.plovlover.crossword")
        
        queue.async {
            let crosswordsGenerator = ForwardCheck()
            crosswordsGenerator.words = ["saffron", "pumpernickel", "leaven", "coda", "paladin", "syncopation", "albatross", "harp", "piston", "caramel", "coral", "dawn", "pitch", "fjord", "lip", "lime", "mist", "plague", "yarn", "snicker", "pidar", "zaibal", "doxuya", "govorish", "yeblan", "chmoshnik"]
            crosswordsGenerator.columns = 30
            crosswordsGenerator.rows = 28
            
            crosswordsGenerator.debug = false
            //crosswordsGenerator.fillAllWords = true
            
            var bestResult: Array = Array<Any>()
            var printable = Array<Array<String>>()
            let attempts = 1
            
            for _ in 0...attempts {
                crosswordsGenerator.generateWithForwardChecking()
                let result = crosswordsGenerator.result
                
                if result.count > bestResult.count {
                    bestResult.removeAll()
                    for word in result {
                        bestResult.append(word)
                    }
                    
                    printable = crosswordsGenerator.currentPrintable
                }
                
            }
            print("br: \(bestResult.count), words: \(crosswordsGenerator.words.count)")
            
//            DispatchQueue.main.async {
//                self.scene.drawCrossword(print: printable)
//            }
            
        }

    }
    
    
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
