//
//  TestFBViewController.swift
//  Nazari_Mirabutaleb_IAD
//
//  Created by Mirabutaleb Nazari on 12/10/15.
//  Copyright © 2015 Mirabutaleb Nazari. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class TestFBViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
		let loginButton : FBSDKLoginButton = FBSDKLoginButton()
		loginButton.center = self.view.center
		self.view.addSubview(loginButton)

		
    }

	override func viewDidAppear(animated: Bool) {
		
		let object = FBSDKShareOpenGraphObject(properties: ["og:type": "game.achievement","og:title" : "Polyblox", "og:description" : "This is my first post from Polyblox."])
		
		let action = FBSDKShareOpenGraphAction()
		action.actionType = "games.celebrate"
		action.setObject(object, forKey: "poly:blox")
		
		let content = FBSDKShareOpenGraphContent()
		content.action = action
		content.previewPropertyName = "poly:blox"
		
		FBSDKShareDialog.showFromViewController(self, withContent: content, delegate: nil)
		
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
