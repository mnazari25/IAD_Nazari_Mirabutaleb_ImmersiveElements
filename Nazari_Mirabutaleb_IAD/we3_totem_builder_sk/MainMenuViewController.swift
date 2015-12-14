//
//  MainMenuViewController.swift
//  we3_totem_builder_sk
//
//  Created by Mirabutaleb Nazari on 9/21/15.
//  Copyright (c) 2015 Mirabutaleb Nazari. All rights reserved.
//

import UIKit
import Social
import GameKit
import FBSDKCoreKit

class MainMenuViewController: UIViewController, GKGameCenterControllerDelegate {

	@IBOutlet weak var nameField: UITextField!
	var font = UIFont(name: "ZNuscript", size: 65)
	var noobie = false
	let userDefaults = NSUserDefaults.standardUserDefaults();
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		nameField.borderStyle = UITextBorderStyle.RoundedRect;
		nameField.font = font
		
		userDefaults.setBool(true, forKey: "updated")
		
		if !GKLocalPlayer.localPlayer().authenticated {
			
			gameCenterLogin()
			
		}
		
    }
	
	@IBAction func ShareToFacebook(sender: UIButton) {
		
		let share : SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
		
		share.setInitialText("I've been playing this awesome game called Polyblox! You should check it out.")
		
		self.presentViewController(share, animated: true, completion: nil)
		
	}
	
	
	@IBAction func playGame(sender: UIButton) {
		
		performSegueWithIdentifier("toProfileVC", sender: self)
		
	}
	
	@IBAction func showLeaderBoard(sender: UIButton) {
	
		highscores()

	}
	
	func highscores() {
		
		print("attempting to show high scores")
		
		if GKLocalPlayer.localPlayer().authenticated {
			
			let vc = self
			let gc = GKGameCenterViewController()
			gc.gameCenterDelegate = self
			vc.presentViewController(gc, animated: true, completion: nil)
			
		} else {
			
			gameCenterLogin()
			
		}
		
	}
	
	func gameCenterLogin() {
		
		let localPlayer = GKLocalPlayer.localPlayer()
		
		localPlayer.authenticateHandler = {(vc, error) -> Void in
			
			if (vc != nil) {

				UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(vc!, animated: true, completion: nil)
				
			}
				
			else {
				
//				if GKLocalPlayer.localPlayer().authenticated {
//					
//					self.highscores()
//					
//				}
				print((GKLocalPlayer.localPlayer().authenticated))
				
			}
			
		}
		
	}
	
	@IBAction func storyMode(sender: UIButton) {
		
		if !noobie {
			
			performSegueWithIdentifier("toStoryVC", sender: self)
			
		} else {
			
			performSegueWithIdentifier("toLevelSelect", sender: self)
			
		}
		
	}
	
	
	override func viewDidAppear(animated: Bool) {
		
		nameField.text = ""
		noobie = userDefaults.boolForKey("noobie")
		if let levels = userDefaults.objectForKey("levelData") as? NSData {
			
			if let levelData = NSKeyedUnarchiver.unarchiveObjectWithData(levels) as? [String : [GameLevel]] {
				
				sections = levelData
				
			}
			
		}
		
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let gameVC = segue.destinationViewController as? ProfileViewController {
			
			gameVC.name = nameField.text!
			
		}
		
		if let storyVC = segue.destinationViewController as? StoryViewController {
			
			storyVC.name = nameField.text!
			
		}
		
	}
	
}

extension MainMenuViewController : UITextFieldDelegate {
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()
		return true
		
	}
	
	func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
	{
		
		gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
		
	}
	
}










