//
//  CreditsViewController.swift
//  we3_totem_builder_sk
//
//  Created by Mirabutaleb Nazari on 9/19/15.
//  Copyright (c) 2015 Mirabutaleb Nazari. All rights reserved.
//

import UIKit

class CreditsViewController: UIViewController {

	@IBOutlet weak var bigRedButton: UIButton!
	
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		bigRedButton.layer.cornerRadius = bigRedButton.layer.frame.size.width * 2
		
    }
	
	@IBAction func bigRedButtonTapped(sender: UIButton) {
		
		let alert = UIAlertController(title: "Are you sure?", message: "This will clear all saved data.", preferredStyle: UIAlertControllerStyle.Alert)
		
		alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
		alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { (alertview) -> Void in
			
			sections = ["Level 1" : [GameLevel(), GameLevel(), GameLevel(),GameLevel(), GameLevel(), GameLevel()], "Level 2" : [GameLevel(), GameLevel(), GameLevel(),GameLevel(), GameLevel(), GameLevel()], "Level 3" : [GameLevel(), GameLevel(), GameLevel(),GameLevel(), GameLevel(), GameLevel()], "Level 4" : [GameLevel(), GameLevel(), GameLevel(),GameLevel(), GameLevel(), GameLevel()]]
		
			let userDefaults = NSUserDefaults.standardUserDefaults();
			let myEncodedObject = NSKeyedArchiver.archivedDataWithRootObject(sections);
			
			userDefaults.setObject(myEncodedObject, forKey: "levelData")
			userDefaults.setBool(false, forKey: "noobie")
			NSUserDefaults.standardUserDefaults().setBool(false, forKey: "champion")
			
			let alert = UIAlertController(title: "Deleted", message: "Your app is now shiny and clean!", preferredStyle: UIAlertControllerStyle.Alert)
			
			alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (alertviewaction) -> Void in
				(UIApplication.sharedApplication().keyWindow?.rootViewController)?.dismissViewControllerAnimated(true, completion: nil)
			}))
			
			self.presentViewController(alert, animated: true, completion: nil)
			
		}))
		
		self.presentViewController(alert, animated: true, completion: nil)
		
	}
	@IBAction func back(sender: UITapGestureRecognizer) {
		
		self.dismissViewControllerAnimated(true, completion: nil)
		
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
