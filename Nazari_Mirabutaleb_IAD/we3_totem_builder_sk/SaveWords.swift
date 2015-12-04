//
//  SaveWords.swift
//  we3_totem_builder_sk
//
//  Created by Mirabutaleb Nazari on 9/23/15.
//  Copyright (c) 2015 Mirabutaleb Nazari. All rights reserved.
//

import Foundation

class SaveWords : NSObject, NSCoding {
	
	var words : [String] = []
	
	func encodeWithCoder(aCoder: NSCoder) {
		
		aCoder.encodeObject(words, forKey: "words")
		
	}
	
	required convenience init?(coder aDecoder: NSCoder) {
		self.init()
		
		// rules for unpacking an NSData object
		words = aDecoder.decodeObjectForKey("words") as! [String]
		
	}
	
}