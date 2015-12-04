//
//  HelpfulExtensions.swift
//  Swift - UIElements MISC
//
//  Created by Mirabutaleb Nazari on 1/9/15.
//  Copyright (c) 2015 Bug Catcher Studios. All rights reserved.
//

import Foundation


// extensions can only add functionality
extension String {
	
	// convert a string to a double if possible
	func double() -> Double?{
		// trims whitespace from front and back
		let trimmedString = self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
		// get each number on both sides of the decimal
		let numbers = trimmedString.componentsSeparatedByString(".")
		// if we didn't get a array that resulted in two items when separated, return nil
		if numbers.count != 2 {
			
			if let number = Int((numbers[0] as String)) {
				
				return Double(number)
				
			}
			
			return nil
		}
		
		// if the components we got back weren't convertible to an integer, return nil
		for number in numbers {
			
			if Int(number) == nil {
				
				return nil
				
			}
			
		}
		
		// make double
		var doubleValue = Double(Int(numbers[0])!)
		// determines number of characters to divide by appropiate power of 10
		let numberCharacters = Double(numbers[1].characters.count)
		let numberToDivide = pow(10.0,numberCharacters)
		let afterDecimal = Double(Int(numbers[1])!) / numberToDivide
		
		doubleValue += afterDecimal
		
		return doubleValue
		
	}
	
}

func arrayFromContentsOfFileWithName(fileName: String) -> [String]? {
	
	if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt") {
		
		do {
			let content = try String(contentsOfFile:path, encoding: NSUTF8StringEncoding)
			
			var catchArray : [String] = []
			let arrayOfWords = content.componentsSeparatedByString("\n")
			
			for word in arrayOfWords {
				
				if (Array(word.characters).count < 6 && Array(word.characters).count > 2) {
					
					catchArray.append(word)
					
				}
				
			}
			
			return catchArray
			
		} catch _ {
			
			
			
		}
		
	}
	
	return nil
	
}


/// NS USER DEFAULTS GLOBAL SAVE AND LOAD
func saveCustomObject(obj: SaveWords) {
	
	let userDefaults = NSUserDefaults.standardUserDefaults();
	let myEncodedObject = NSKeyedArchiver.archivedDataWithRootObject(obj);
	
	userDefaults.setObject(myEncodedObject, forKey: "wordArray");
	
}

func loadCustomObjectWithKey(key: String) -> SaveWords? {
	
	let userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults();
	let myEncodedObject : NSData? = userDefaults.objectForKey(key) as? NSData;
	
	if myEncodedObject != nil {
		let obj = NSKeyedUnarchiver.unarchiveObjectWithData(myEncodedObject!) as? SaveWords;
		return obj;
	} else {
		return nil;
	}
}