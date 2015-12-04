//
//  GameLevel.swift
//  Nazari_Mirabutaleb_IAD
//
//  Created by Mirabutaleb Nazari on 12/3/15.
//  Copyright © 2015 Mirabutaleb Nazari. All rights reserved.
//

import Foundation

class GameLevel : NSObject, NSCoding {
	
	var storedWord = ""
	var isLocked = true
	var numTaps = 0
	var bestTaps = 1
	var section = 0
	var level = 0
	
	func encodeWithCoder(aCoder: NSCoder) {
		
		aCoder.encodeObject(storedWord, forKey: "levelWord")
		aCoder.encodeBool(isLocked, forKey: "isLocked")
		aCoder.encodeInteger(numTaps, forKey: "numTaps")
		aCoder.encodeInteger(bestTaps, forKey: "bestTaps")
		
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		self.init()
		
		// rules for unpacking an NSData object
		storedWord = aDecoder.decodeObjectForKey("levelWord") as! String
		isLocked = aDecoder.decodeBoolForKey("isLocked")
		numTaps = aDecoder.decodeIntegerForKey("numTaps")
		bestTaps = aDecoder.decodeIntegerForKey("bestTaps")
		
	}
	
}