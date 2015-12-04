//
//  HelpViewController.swift
//  we3_totem_builder_sk
//
//  Created by Mirabutaleb Nazari on 9/19/15.
//  Copyright (c) 2015 Mirabutaleb Nazari. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {

	var imageName = ""
	@IBOutlet weak var daImageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		
		if imageName != "" {
			
			daImageView.image = UIImage(named: imageName)
			
		}
		
    }
	@IBAction func back(sender: AnyObject) {
		
		self.dismissViewControllerAnimated(true, completion: nil)
		
	}

}
