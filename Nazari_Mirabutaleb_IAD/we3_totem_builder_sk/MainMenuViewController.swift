//
//  MainMenuViewController.swift
//  we3_totem_builder_sk
//
//  Created by Mirabutaleb Nazari on 9/21/15.
//  Copyright (c) 2015 Mirabutaleb Nazari. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

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
		
    }
	
	@IBAction func playGame(sender: UIButton) {
		
		performSegueWithIdentifier("toProfileVC", sender: self)
		
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
	
}










