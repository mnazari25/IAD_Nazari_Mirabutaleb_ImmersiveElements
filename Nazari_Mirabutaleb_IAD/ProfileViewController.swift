//
//  ProfileViewController.swift
//  we3_totem_builder_sk
//
//  Created by Mirabutaleb Nazari on 11/7/15.
//  Copyright © 2015 Mirabutaleb Nazari. All rights reserved.
//

import UIKit
import GameKit

class ProfileViewController: UIViewController {

	var font = UIFont(name: "ZNuscript", size: 65)
	var name = ""
	var gameMode = ""
	var wordArray : [String] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func chooseGrade(sender: UIButton) {
		
		let fileNumber = sender.tag
		if let Array = arrayFromContentsOfFileWithName("p-\(fileNumber)_ok") {
			
			switch fileNumber {
				
			case 0:
				gameMode = "iad_prek"
			case 1:
				gameMode = "iad_k"
			case 2:
				gameMode = "iad_1"
			case 3:
				gameMode = "iad_2"
			case 4:
				gameMode = "iad_3"
			case 5:
				gameMode = "iad_4"
			default:
				break
				
			}
			words = Array
			wordArray = Array
			performSegueWithIdentifier("toGameVC", sender: nil)
			
		}
		
	}
	
	@IBAction func dismiss(sender: UIButton) {
		
		(UIApplication.sharedApplication().keyWindow?.rootViewController)?.dismissViewControllerAnimated(false, completion: nil)
//		self.dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let gameVC = segue.destinationViewController as? GameViewController {
			
			gameVC.name = self.name
			gameVC.gameMode = self.gameMode
			
		}
		
	}
	
}
