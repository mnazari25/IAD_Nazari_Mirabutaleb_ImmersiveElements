//
//  LetterBlock.swift
//  we3_totem_builder_sk
//
//  Created by Mirabutaleb Nazari on 9/18/15.
//  Copyright (c) 2015 Mirabutaleb Nazari. All rights reserved.
//

import Foundation
import SpriteKit

class LetterBlock : SKSpriteNode {
	
	var tag = 0
	var letters : [Letters] = []
	var chosenLetter = 0  // stores chosen letter for word
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	init(imageNamed: String) {
		
		let imageTexture = SKTexture(imageNamed: imageNamed)
		super.init(texture: imageTexture, color: UIColor(), size: imageTexture.size())
		
	}
	
	func changeFaces() {
		
		chosenLetter++
		if chosenLetter >= letters.count {
			
			chosenLetter = 0
			
		}
		
		self.texture = SKTexture(imageNamed: letters[chosenLetter].letterPictures[tag])
		
	}
	
}