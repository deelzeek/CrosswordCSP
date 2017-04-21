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
import Foundation

class GameViewController: UIViewController {

    @IBOutlet var crosswordView: SKView!
    @IBOutlet var wordsView: UITextView!
    @IBOutlet var createCross: UIButton!
    @IBOutlet var btBacktrack: UIButton!
    @IBOutlet var btForwardtrack: UIButton!
    
    var scene: GameScene!
    var level: Level!
    var words : Array<String> = Array()
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        importWordsFromFile()
    }
    
    func importWordsFromFile() {
        
        let filePath = Bundle.main.path(forResource: "lemma", ofType: "txt")
        
        if let aStreamReader = StreamReader(path: filePath!) {
            defer {
                aStreamReader.close()
            }
            while let line = aStreamReader.nextLine() {
                let arr = line.components(separatedBy: " ")
                
                if !arr.isEmpty && !arr[3].contains("-"){
                    if arr[3] == "v" || arr[3] == "adv" || arr[3] == "n" || arr[3] == "a" {
                        words.append(arr[2])
                    }
                }
            }
        }
        
        self.words.shuffle()
        
        //print("Words: \(self.words)")
    }
    
    func beginGame() {
        shuffle()
    }
    
    func shuffle() {
        let newLetters = level.shuffle()
        scene.addSprites(for: newLetters)
    }

    @IBAction func onCreateCross(_ sender: Any) {
        let queue = DispatchQueue(label: "uz.plovlover.crossword")
        
        queue.async {
            let crosswordsGenerator = CrosswordsGenerator()
            crosswordsGenerator.words = self.words
            crosswordsGenerator.columns = 30
            crosswordsGenerator.rows = 28
            
            crosswordsGenerator.occupyPlaces = false
            crosswordsGenerator.debug = false
            //crosswordsGenerator.fillAllWords = true
            
            crosswordsGenerator.occupyPlaces = false
            
            var bestResult: Array = Array<Any>()
            var printable = Array<Array<String>>()
            let attempts = 1
            
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
            crosswordsGenerator.words = self.words
            crosswordsGenerator.columns = 30
            crosswordsGenerator.rows = 28
            crosswordsGenerator.amountOfWordsToFit = 25
            crosswordsGenerator.occupyPlaces = true
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
            let crosswordsGenerator = CrosswordsGenerator()
            crosswordsGenerator.words = self.words
            crosswordsGenerator.columns = 30
            crosswordsGenerator.rows = 28
            crosswordsGenerator.amountOfWordsToFit = 25
            crosswordsGenerator.debug = false
            crosswordsGenerator.occupyPlaces = false
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
            
            DispatchQueue.main.async {
                self.scene.drawCrossword(print: printable)
            }
            
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
