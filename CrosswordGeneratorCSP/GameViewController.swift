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
        for char in "AB".characters {
            words.append("\(char)")
        }

        self.words.shuffle()
    }
    
    func beginGame() {
        shuffle()
    }
    
    func shuffle() {
        let newLetters = level.shuffle()
        scene.addSprites(for: newLetters)
    }

    @IBAction func onCreateCross(_ sender: Any) {
        let queue = DispatchQueue(label: QUEUE_NAME)
        
        self.btBacktrack.isEnabled = false
        self.btForwardtrack.isEnabled = false
        
        queue.async {
            let crosswordsGenerator = MozaicGenerator()
            crosswordsGenerator.words = self.words
            crosswordsGenerator.columns = COLUMNS
            crosswordsGenerator.rows = ROWS
            
            //crosswordsGenerator.occupyPlaces = true
            crosswordsGenerator.debug = false
            //crosswordsGenerator.fillAllWords = true
            
            crosswordsGenerator.occupyPlaces = false
            
            var bestResult: Array = Array<Any>()
            var printable = Array<Array<String>>()

            crosswordsGenerator.generateMozaic()
            let result = crosswordsGenerator.result
            
            if result.count > bestResult.count {
                bestResult.removeAll()
                for word in result {
                    bestResult.append(word)
                }
                
                printable = crosswordsGenerator.currentPrintable
            }
            
            //print("br: \(bestResult.count), words: \(crosswordsGenerator.words.count)")

            DispatchQueue.main.async {
                self.scene.drawCrossword(print: printable)
                var printWords = CHOSEN_WORDS
                self.wordsView.text = ""
                for word in crosswordsGenerator.chosenWords {
                    printWords += "\(word)\n"
                }
                self.btBacktrack.isEnabled = true
                self.btForwardtrack.isEnabled = true
                self.wordsView.text  = printWords
            }

        }
        
    }
    
    @IBAction func onBacktrackAction(_ sender: Any) {
        
        self.btForwardtrack.isEnabled = false
        self.createCross.isEnabled = false
        let queue = DispatchQueue(label: QUEUE_NAME)
        queue.async {
            let crosswordsGenerator = MozaicGenerator()
            crosswordsGenerator.words = self.words
            crosswordsGenerator.columns = COLUMNS
            crosswordsGenerator.rows = ROWS
            //crosswordsGenerator.amountOfWordsToFit = NUMBER_OF_WORDS
            crosswordsGenerator.occupyPlaces = false
            crosswordsGenerator.debug = true
            //crosswordsGenerator.fillAllWords = true
            
            var bestResult: Array = Array<Any>()
            var printable = Array<Array<String>>()
            
            crosswordsGenerator.generateWithBacktrack()
            let result = crosswordsGenerator.result
            
            if result.count > bestResult.count {
                bestResult.removeAll()
                for word in result {
                    bestResult.append(word)
                }
                
                printable = crosswordsGenerator.currentPrintable
            }
            
            DispatchQueue.main.async {
                self.scene.drawCrossword(print: printable)
                var printWords = CHOSEN_WORDS
                self.wordsView.text = ""
                for word in crosswordsGenerator.chosenWords {
                    printWords += "\(word)\n"
                }
                self.btForwardtrack.isEnabled = true
                self.createCross.isEnabled = true
                
                self.wordsView.text  = printWords
            }
        }
    }
    
    
    @IBAction func onForwardtreackAction(_ sender: Any) {
        
        self.btBacktrack.isEnabled = false
        self.createCross.isEnabled = false
        
        let queue = DispatchQueue(label: QUEUE_NAME)
        
        queue.async {
            let crosswordsGenerator = MozaicGenerator()
            crosswordsGenerator.words = self.words
            crosswordsGenerator.columns = COLUMNS
            crosswordsGenerator.rows = ROWS
            crosswordsGenerator.amountOfWordsToFit = NUMBER_OF_WORDS
            crosswordsGenerator.debug = false
            crosswordsGenerator.occupyPlaces = false
            //crosswordsGenerator.fillAllWords = true
            
            var bestResult: Array = Array<Any>()
            var printable = Array<Array<String>>()
            
            crosswordsGenerator.generateWithForwardChecking()
            let result = crosswordsGenerator.result
            
            for word in result {
                bestResult.append(word)
            }
            
            printable = crosswordsGenerator.currentPrintable
            
            debugPrint("br: \(bestResult.count), words: \(crosswordsGenerator.words.count)")
            
            DispatchQueue.main.async {
                self.scene.drawCrossword(print: printable)
                self.wordsView.text = ""
                var printWords = CHOSEN_WORDS
                for word in crosswordsGenerator.chosenWords {
                    printWords += "\(word)\n"
                }
                self.btBacktrack.isEnabled = true
                self.createCross.isEnabled = true
                
                self.wordsView.text  = printWords
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
