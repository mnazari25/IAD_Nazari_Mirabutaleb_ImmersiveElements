//
//  GameViewController.swift
//  we3_totem_builder_sk
//
//  Created by Mirabutaleb Nazari on 9/14/15.
//  Copyright (c) 2015 Mirabutaleb Nazari. All rights reserved.
//

import UIKit
import SpriteKit
import GameKit

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

	@IBOutlet weak var menuButtonOutlet: UIButton!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet var uiElements: [UIButton]!
	var name = ""
	var storyMode = false
	var level : GameLevel?
	var gameMode = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if !name.isEmpty {
			
			nameLabel.text = "HELLO, \(name.uppercaseString)."
			
		} else {
			
			nameLabel.text = "HELLO, GUEST."
			
		}
		
		if !storyMode {

			menuButtonOutlet.hidden = true
			menuButtonOutlet.setBackgroundImage(UIImage(named: "pause"), forState: .Normal)
			
		} else {
			
			menuButtonOutlet.setBackgroundImage(UIImage(named: "back"), forState: .Normal)
			
		}
		
		if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
			// Configure the view.
			
			scene.storyMode = self.storyMode
			scene.gameLevel = level
			scene.gameMode = self.gameMode
			
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
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "togglePause:", name: "togglePause", object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "highScoresCalled:", name: "gameCenter", object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "facebookMessage:", name: "facebookMessage", object: nil)
		
    }
	
	func winner(notification: NSNotification) {
		
		
		
	}
	
	func togglePause(notification: NSNotification) {
		
		menuButtonOutlet.hidden = !menuButtonOutlet.hidden
		
	}
	
	func dismiss(notification: NSNotification) {
		
		self.dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	func startGame(notification: NSNotification) {

		menuButtonOutlet.hidden = false
		
//		for element in uiElements {
//			
//			element.hidden = false
//			
//		}
		
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
	
	func facebookMessage(notification : NSNotification) {
		
		let transmission = notification.userInfo as Dictionary!
		
		//Access the entries in the dictionary and cast from AnyObject to NSData Object/MCPeerID
		if let receivedPacket = transmission["data"] as? FacebookMessage {
			
			let request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
			
			request.startWithCompletionHandler({ (connection, data, error) -> Void in
				
				if error != nil {
					
					print("well we tried")
					print(error.localizedDescription)
					
				} else {
					
					print(data)
					
				}
				
			})
			
			let object = FBSDKShareOpenGraphObject(properties: ["og:type": "game.achievement","og:title" : "Polyblox", "og:description" : "I just scored a \(receivedPacket.myInt) in Polyblox! Check it out here www.polyblox.com"])
			
			let action = FBSDKShareOpenGraphAction()
			action.actionType = "games.celebrate"
			action.setObject(object, forKey: "poly:blox")
			
			let content = FBSDKShareOpenGraphContent()
			content.action = action
			content.previewPropertyName = "poly:blox"
			
			FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
			
		}
		
		
		
	}
	
	@IBAction func back(sender: UIButton) {
		
		if storyMode {
			
			self.dismissViewControllerAnimated(true, completion: nil)
			
		} else {
			
			NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "pauseMenu", object: nil))
			
		}
		
		
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

extension GameViewController : GKGameCenterControllerDelegate {
	
	func highScoresCalled(notification: NSNotification) {
		
		showHighScores()
		
	}
	
	func gameCenterLogin() {
		
		let localPlayer = GKLocalPlayer.localPlayer()
		
		localPlayer.authenticateHandler = {(vc, error) -> Void in
			
			if (vc != nil) {
				
				UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(vc!, animated: true, completion: nil)
				
			}
				
			else {
				
				if GKLocalPlayer.localPlayer().authenticated {
					
					self.showHighScores()
					
				}
				print((GKLocalPlayer.localPlayer().authenticated))
				
			}
			
		}
		
	}
	
	func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
	{
		
		gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	func showHighScores() {
		
		if GKLocalPlayer.localPlayer().authenticated {
			
			let vc = self
			let gc = GKGameCenterViewController()
			gc.gameCenterDelegate = self
			vc.presentViewController(gc, animated: true, completion: nil)
			
		} else {
			
			gameCenterLogin()
			
		}
		
	}
	
}
