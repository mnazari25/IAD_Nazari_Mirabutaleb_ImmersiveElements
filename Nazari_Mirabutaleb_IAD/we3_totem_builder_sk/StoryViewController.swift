//
//  StoryViewController.swift
//  Nazari_Mirabutaleb_IAD
//
//  Created by Mirabutaleb Nazari on 12/2/15.
//  Copyright © 2015 Mirabutaleb Nazari. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {

	var imageNames = ["Story_1", "Story_2", "Story_3", "How_to_play"]
	var currentImage = 0
	var name = ""
	var noobie = true
	
	@IBOutlet weak var storyImageOutlet: UIImageView!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet weak var previousButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		storyImageOutlet.image = UIImage(named: imageNames[currentImage])
		currentImage = 1
		
        // Do any additional setup after loading the view.
		
    }

	@IBAction func previousImage(sender: UIButton) {
		
		currentImage -= 2
		imageFadeIn(storyImageOutlet)
		currentImage++
		
		if currentImage == 1 {
			
			previousButton.hidden = true
			
		}
		
	}
	
	
	@IBAction func nextImage(sender: UIButton) {
		
		if currentImage < imageNames.count {
			
			imageFadeIn(storyImageOutlet)
			currentImage++
			previousButton.hidden = false
			
		} else {
			
			performSegueWithIdentifier("toLevelSelect", sender: self)
			
		}
		
	}
	
	func imageFadeIn(imageView: UIImageView) {
		
		let secondImageView = UIImageView(image: UIImage(named: imageNames[currentImage]))
		secondImageView.frame = view.frame
		secondImageView.alpha = 0.0
		
		view.insertSubview(secondImageView, aboveSubview: imageView)
		
		UIView.animateWithDuration(2.0, delay: 0, options: UIViewAnimationOptions.TransitionCurlUp, animations: {
			secondImageView.alpha = 1.0
			
			}, completion: {_ in
				imageView.image = secondImageView.image
				secondImageView.removeFromSuperview()
		})
		
	}
	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		
		
		
    }


}
