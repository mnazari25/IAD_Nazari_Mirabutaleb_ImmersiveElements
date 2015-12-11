//
//  FacebookMessage.swift
//  Nazari_Mirabutaleb_IAD
//
//  Created by Mirabutaleb Nazari on 12/10/15.
//  Copyright © 2015 Mirabutaleb Nazari. All rights reserved.
//

import Foundation

class FacebookMessage {
	
	var myInt = 0
	
	func encodeWithCoder(encoder: NSCoder) {
		
		encoder.encodeInteger(myInt, forKey: "score")
		
	}
	
	func initWithCoder(decoder: NSCoder) -> AnyObject {
		
		self.myInt = decoder.decodeIntegerForKey("score")
		
		return self
		
	}
	
}