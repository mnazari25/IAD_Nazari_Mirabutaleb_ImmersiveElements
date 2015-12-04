//
//  GameViewController.swift
//  we3_totem_builder_sk
//
//  Created by Mirabutaleb Nazari on 9/14/15.
//  Copyright (c) 2015 Mirabutaleb Nazari. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            let sceneData = try! NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe)
            let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

var words = ["bad"]
var sections = ["Level 1" : [GameLevel(), GameLevel(), GameLevel(),GameLevel(), GameLevel(), GameLevel()], "Level 2" : [GameLevel(), GameLevel(), GameLevel(),GameLevel(), GameLevel(), GameLevel()], "Level 3" : [GameLevel(), GameLevel(), GameLevel(),GameLevel(), GameLevel(), GameLevel()], "Level 4" : [GameLevel(), GameLevel(), GameLevel(),GameLevel(), GameLevel(), GameLevel()]]

class GameViewController: UIViewController {

	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet var uiElements: [UIButton]!
	var name = ""
	var storyMode = false
	var level : GameLevel?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if !name.isEmpty {
			
			nameLabel.text = "HELLO, \(name.uppercaseString)."
			
		} else {
			
			nameLabel.text = "HELLO, GUEST."
			
		}
		
		if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
			// Configure the view.
			
			scene.storyMode = self.storyMode
			scene.gameLevel = level
			
			let skView = self.view as! SKView
			// skView.showsFPS = true
			// skView.showsNodeCount = true
			
			/* Sprite Kit applies additional optimizations to improve rendering performance */
			skView.ignoresSiblingOrder = true
			
			/* Set the scale mode to scale to fit the window */
			scene.scaleMode = .AspectFill
			
			skView.presentScene(scene)
		}
		
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "dismiss:", name: "dismiss", object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "winner:", name: "winnerwinner", object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "startGame:", name: "startGame", object: nil)
		
    }
	
	func winner(notification: NSNotification) {
		
		
		
	}
	
	func dismiss(notification: NSNotification) {
		
		self.dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	func startGame(notification: NSNotification) {
		
		for element in uiElements {
			
			element.hidden = false
			
		}
		
	}
	
	@IBAction func helpMe(sender: UIButton) {
	
		self.performSegueWithIdentifier("helpDetail", sender: sender)
		
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let helpVC = segue.destinationViewController as? HelpViewController {
			
			if let button = sender as? UIButton {
				
				switch button.tag {
					
				case 0:
					helpVC.imageName = "abc"
				case 1:
					helpVC.imageName = "sign"
				case 2:
					helpVC.imageName = "braille"
				default:
					break
					
				}
				
			}
			
		}
		
	}

    override func shouldAutorotate() -> Bool {
        return true
    }
	
	@IBAction func back(sender: UIButton) {
		
		self.dismissViewControllerAnimated(true, completion: nil)
	
	}
	

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return UIInterfaceOrientationMask.AllButUpsideDown
        } else {
            return UIInterfaceOrientationMask.All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
