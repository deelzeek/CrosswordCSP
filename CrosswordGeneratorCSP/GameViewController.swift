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
    
    private var scene: GameScene!
    private var level: Level!
    private var words : Array<String> = Array()
    
    private var Square8x8: String.CharacterView {
        return "4816325736721654234828614165773572318512356731846423547887142356".characters
    }
    
    private var Square6x6: String.CharacterView {
        return "142354425155521634465552316424115363".characters
    }
    
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
        switch COLUMNS {
        case 8:
            for char in Square8x8 {
                words.append("\(char)")
            }
        case 6:
            for char in Square6x6 {
                words.append("\(char)")
            }
        case 10:
            for digit in [11,10, 2, 11, 10, 4, 1, 3, 10, 8,
                          2, 7, 6, 10, 11, 5, 3, 5, 8, 1,
                          7, 5, 1, 5, 5, 4, 7, 8, 3, 6,
                          6, 9, 3, 9, 6, 4, 10, 1, 2, 11,
                          1, 10, 11, 2, 4, 8, 6, 1, 9, 3,
                          3, 2, 10, 4, 7, 1, 8, 11, 3, 9,
                          6, 10, 5, 4, 11, 11, 6, 5, 1, 2,
                          8, 6, 5, 3, 9, 1, 4, 4, 2, 7,
                          8, 3, 9, 11, 5, 3, 5, 7, 11, 4,
                          10, 8, 4, 10, 3, 6, 8, 2, 11, 11,
                          1, 1, 7, 8, 3, 2, 11, 3, 7, 5,
                          5, 3, 8, 7, 1, 10, 2, 9, 10, 6,
                          2, 4, 7, 5, 8, 9, 4, 6, 11, 10] {
                words.append(String(digit))
            }
        default:
            break
        }
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
            let crosswordsGenerator = HirokiGenerator()
            crosswordsGenerator.hirokiTemplate = self.words
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
                //self.wordsView.text  = printWords
            }

        }
        
    }
    
    @IBAction func onBacktrackAction(_ sender: Any) {
        
        self.btForwardtrack.isEnabled = false
        self.createCross.isEnabled = false
        let queue = DispatchQueue(label: QUEUE_NAME)
        queue.async {
            let crosswordsGenerator = HirokiGenerator()
            crosswordsGenerator.hirokiTemplate = self.words
            crosswordsGenerator.columns = COLUMNS
            crosswordsGenerator.rows = ROWS
            crosswordsGenerator.occupyPlaces = false
            crosswordsGenerator.debug = true
            
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
                
                //self.wordsView.text  = printWords
            }
        }
    }
    
    
    @IBAction func onForwardtreackAction(_ sender: Any) {
        
        self.btBacktrack.isEnabled = false
        self.createCross.isEnabled = false
        
        let queue = DispatchQueue(label: QUEUE_NAME)
        
        queue.async {
            let crosswordsGenerator = HirokiGenerator()
            crosswordsGenerator.hirokiTemplate = self.words
            crosswordsGenerator.columns = COLUMNS
            crosswordsGenerator.rows = ROWS
            //crosswordsGenerator.amountOfWordsToFit = NUMBER_OF_WORDS
            crosswordsGenerator.debug = true
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
                
                //self.wordsView.text  = printWords
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
