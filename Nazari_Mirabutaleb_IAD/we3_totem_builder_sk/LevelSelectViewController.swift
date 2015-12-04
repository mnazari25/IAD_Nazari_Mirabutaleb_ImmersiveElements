//
//  LevelSelectViewController.swift
//  Nazari_Mirabutaleb_IAD
//
//  Created by Mirabutaleb Nazari on 12/3/15.
//  Copyright © 2015 Mirabutaleb Nazari. All rights reserved.
//

import UIKit

class LevelSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

	@IBOutlet weak var daCollectionView: UICollectionView!
	var selectedGame : GameLevel = GameLevel()
	
	var allUnlocked = true
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		NSUserDefaults.standardUserDefaults().setBool(true, forKey: "noobie")
		
    }
	
	override func viewDidAppear(animated: Bool) {
		
		daCollectionView.reloadData()
		isGameOver()
		
	}
	
	func isGameOver() {
		
		for (_,value) in sections {
			
			for game in value {
				
				if game.isLocked {
					
					allUnlocked = false
					return
					
				}
				
			}
			
		}
		
		if allUnlocked {
			
			print("You win everything!!")
			
			if !NSUserDefaults.standardUserDefaults().boolForKey("champion") {
				
				let alert = UIAlertController(title: "Congratulations!", message: "You have beaten the game. Please feel free to keep playing these levels or restart the game. Have fun!", preferredStyle: UIAlertControllerStyle.Alert)
				
				alert.addAction(UIAlertAction(title: "Awesome!", style: .Default, handler: nil))
				
				self.presentViewController(alert, animated: true, completion: nil)
				
			}
			
			NSUserDefaults.standardUserDefaults().setBool(true, forKey: "champion")
			
		}
		
	}
	
	@IBAction func dismiss(sender: UIButton) {
		(UIApplication.sharedApplication().keyWindow?.rootViewController)?.dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		return (sections["Level \(section + 1)"]!.count)
		
	}
	
	func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		
		if kind == UICollectionElementKindSectionHeader {
			
			let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "headerReuse", forIndexPath: indexPath) as! LevelHeaderView
			
			var stageString = "STAGE \(indexPath.section + 1)"
			
			switch indexPath.section {
				
			case 0:
				stageString += " - Database"
			case 1:
				stageString += " - Server"
			case 2:
				stageString += " - Mainframe"
			case 3:
				stageString += " - Final Stage"
			default:
				break
				
			}
			
			header.headerLabelText.text = stageString
			
			return header
			
		} else {
			
			return UICollectionReusableView()
			
		}
		
	}
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		
		return sections.count
		
	}
	
	func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
		
	}
	
	func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
		
		if !sections["Level \(indexPath.section + 1)"]![indexPath.row].isLocked {
			
			if let cell = daCollectionView.cellForItemAtIndexPath(indexPath) as? LevelSelectCell {
				
				cell.dimmerView.hidden = true
				
			}
			
		}
		
	}
	
	func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
		
		if !sections["Level \(indexPath.section + 1)"]![indexPath.row].isLocked {
			
			if let cell = daCollectionView.cellForItemAtIndexPath(indexPath) as? LevelSelectCell {
				
				cell.dimmerView.hidden = false
				
			}
			
		}
		
	}
	
	func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

		
		if !sections["Level \(indexPath.section + 1)"]![indexPath.row].isLocked {
			
			sections["Level \(indexPath.section + 1)"]![indexPath.row].section = indexPath.section + 1
			
			sections["Level \(indexPath.section + 1)"]![indexPath.row].level = indexPath.row
			
			selectedGame = sections["Level \(indexPath.section + 1)"]![indexPath.row]
			
			if indexPath.section <= 5 {
				
				if let Array = arrayFromContentsOfFileWithName("p-\(indexPath.section + 1)_ok") {
					
					words = Array
					performSegueWithIdentifier("toGameVC", sender: nil)
					
				}
				
			} else {
				
				if let Array = arrayFromContentsOfFileWithName("p-6_ok") {
					
					words = Array
					performSegueWithIdentifier("toGameVC", sender: nil)
					
				}
				
			}
			
		}
		
	}
	
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellReuse", forIndexPath: indexPath) as! LevelSelectCell
		
		if indexPath.row == 0 && indexPath.section == 0 {
			
			sections["Level \(indexPath.section + 1)"]![indexPath.row].isLocked = false
			
		}
		
		if sections["Level \(indexPath.section + 1)"]![indexPath.row].isLocked {
			
			cell.cellImage.image = UIImage(named: "levelButtonLocked")
			cell.cellLabelText.text = ""
			
		} else {
			
			cell.cellImage.image = UIImage(named: "levelButton")
			cell.cellLabelText.text = "\(indexPath.row + 1)"
			
		}

		cell.dimmerView.layer.cornerRadius = 9
		
		return cell
		
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		if let gameVC = segue.destinationViewController as? GameViewController {
			
			gameVC.storyMode = true
			gameVC.level = selectedGame
			
		}
		
	}

}
