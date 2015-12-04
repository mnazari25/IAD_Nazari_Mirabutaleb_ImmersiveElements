//
//  HowToViewController.swift
//  Nazari_Mirabutaleb_IAD
//
//  Created by Mirabutaleb Nazari on 12/3/15.
//  Copyright © 2015 Mirabutaleb Nazari. All rights reserved.
//

import UIKit

class HowToViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	@IBAction func dismiss(sender: UITapGestureRecognizer) {
		
		self.dismissViewControllerAnimated(true, completion: nil)
		
	}

}
