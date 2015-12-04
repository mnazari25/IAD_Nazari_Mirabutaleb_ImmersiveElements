//
//  Column.swift
//  we3_totem_builder_sk
//
//  Created by Mirabutaleb Nazari on 9/18/15.
//  Copyright (c) 2015 Mirabutaleb Nazari. All rights reserved.
//

import Foundation
import SpriteKit

class Column {
	
	var faces : [LetterBlock] = [] // stores the 6 faces of the column.
	var allMatching = false // bool for match success
	var columnMatch = SKAction.playSoundFileNamed("chaching.wav", waitForCompletion: false)
	
	// func to handle texture change on tap.
	
	func checkForWin() -> Bool {
		
		for var i = 0; i < faces.count; i++ {
			
			if faces[i].chosenLetter == 0 {
				
				allMatching =  true
				
			} else {
				
				return false
				
			}
			
		}
		
		return allMatching
		
	}
	
}