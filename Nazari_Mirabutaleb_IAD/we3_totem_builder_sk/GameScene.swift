//
//  GameScene.swift
//  we3_totem_builder_sk
//
//  Created by Mirabutaleb Nazari on 9/14/15.
//  Copyright (c) 2015 Mirabutaleb Nazari. All rights reserved.
//

import SpriteKit
import GameKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class GameScene: SKScene, GKGameCenterControllerDelegate {

	let STARTCONSTANT = 61
	
	var chosenWord = ""
	var tempWords : [String] = []
	var letters : [Letters] = []
	var defaultLetters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
		"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
	
	var usedLetters : [Letters] = []
	var firstStart = true
	
	var alertImageName = "winMenu_Level"
	
	var columns : [Column] = []
	var didYouWin : [Bool] = []
	var storyMode = false
	var font = UIFont(name: "ZNuscript", size: 30)
	
	var backgroundLayer : SKNode = SKNode()
	var boardLayer : SKNode = SKNode()
	var menuLayer : SKNode = SKNode()
	var alertLayer : SKNode = SKNode()
	
	var blockTouch = SKAction.playSoundFileNamed("beep.wav", waitForCompletion: false)
	var winSound = SKAction.playSoundFileNamed("win.wav", waitForCompletion: false)
	var columnMatch = SKAction.playSoundFileNamed("chaching.wav", waitForCompletion: false)
	
	var wordsOfTheDay : [SKLabelNode] = []
	let timerLabel = SKLabelNode(fontNamed: "Finger Paint")
	let wordCountLabel = SKLabelNode(fontNamed: "ZNuscript")
	
	var gameLevel : GameLevel?
	var gameMode = ""
	
	var wordCount = 0
	var gamePaused = false
	var timerTime = 0
	var lastUpdateTime = CFTimeInterval()
	
	let userDefaults = NSUserDefaults.standardUserDefaults()
	
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
		
		for var i = 0; i < defaultLetters.count; i++ {
			
			let letterToBeAdded = Letters()
			letterToBeAdded.letterPictures = []
			let currentLetter = defaultLetters[i]
			
			timerTime = STARTCONSTANT

			for var j = 1; j < 7; j++ {
				
				(letterToBeAdded.letterPictures).append("\(currentLetter)-Block_\(j)")
				
			}
			
			letters.append(letterToBeAdded)
			
		}
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "pauseMenu:", name: "pauseMenu", object: nil)
		
		tempWords = words
		
		backgroundLayer.zPosition = -100
		self.addChild(backgroundLayer)
		
		boardLayer.zPosition = 1000
		backgroundLayer.addChild(boardLayer)
		
		menuLayer.zPosition = 200
		backgroundLayer.addChild(menuLayer)
		
		alertLayer.zPosition = 3000
		backgroundLayer.addChild(alertLayer)
		
		let sprite = SKSpriteNode(imageNamed: "background")
		sprite.xScale = 1.10
		sprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		sprite.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
		backgroundLayer.addChild(sprite)
		
		let board = SKSpriteNode(imageNamed: "board")
		board.xScale = 0.75
		board.yScale = 0.85
		board.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		board.position = CGPoint(x: self.frame.size.width / 2.2, y: 345)
		boardLayer.addChild(board)
		
		
		if !storyMode {
			
			timerLabel.text = "60"
			timerLabel.fontSize = 60
			timerLabel.fontColor = UIColor.whiteColor()
			timerLabel.position = CGPoint(x: CGRectGetMaxX(self.frame) - 300, y: CGRectGetMaxY(self.frame) - 75)
			boardLayer.addChild(timerLabel)
			
			wordCountLabel.text = "0 words"
			wordCountLabel.fontSize = 70
			wordCountLabel.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMaxY(self.frame) - 75)
			boardLayer.addChild(wordCountLabel)
			
			
			alertImageName = "gameStart"
			showWinMenu()
			
			gamePaused = true
			
		}
		
		if storyMode {
			
			if storyMode && gameLevel!.storedWord != "" {
				
				chosenWord = gameLevel!.storedWord
				makeWord()
				
			} else {
				
				chooseWord()
				
			}
			
			placeBlox()
			
		}
		
    }
	
	func createMenu() {
		
		var yPosition = Double(self.frame.size.height / 2.2)
		let yIncrement = 85.0
		
		for var i = 0; i < 5; i++ {
			
			let menuButton = SKSpriteNode(imageNamed: "Menu_\(i + 1)")
			menuButton.anchorPoint = CGPoint(x: -1, y: 0)
			menuButton.position = CGPoint(
				x: Double(self.size.width / 2),
				y: yPosition)
			menuButton.name = "menu\(i + 1)"
			menuLayer.addChild(menuButton)
			
			yPosition -= yIncrement
			
		}
		
	}
	
	func pauseMenu(notification: NSNotification) {
	
		togglePause()
	
	}
	
	func togglePause() {
		
		gamePaused = !gamePaused
		NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "togglePause", object: nil))
		
		if gamePaused {
			
			createPauseMenu()
			
		} else {
			
			alertLayer.removeAllChildren()
			
		}
		
	}
	
	func createPauseMenu() {
		
		let grayedBack = SKSpriteNode(color: UIColor.blackColor(), size: self.frame.size)
		grayedBack.alpha = 0.5
		grayedBack.anchorPoint = CGPoint(x: 0, y: 0)
		alertLayer.addChild(grayedBack)
		
		let pauseMenu = SKTexture(imageNamed: "pauseMenu_Back")
		let pauseSprite = SKSpriteNode(texture: pauseMenu)
		pauseSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		pauseSprite.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) - 35, y: CGRectGetMidY(grayedBack.frame))
		pauseSprite.zPosition = 310
		pauseSprite.yScale = 0.7
		
		
		let resumeButton = SKTexture(imageNamed: "pauseMenu_Resume")
		let resumeSprite = SKSpriteNode(texture: resumeButton)
		resumeSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		resumeSprite.position = CGPoint(x: 0, y: 85)
		resumeSprite.zPosition = 500
		resumeSprite.yScale = 1.3
		resumeSprite.name = "pause_resume"
		pauseSprite.addChild(resumeSprite)
		
		let restartButton = SKTexture(imageNamed: "pauseMenu_Restart")
		let restartSprite = SKSpriteNode(texture: restartButton)
		restartSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		restartSprite.position = CGPoint(x: 0, y: -30)
		restartSprite.zPosition = 500
		restartSprite.yScale = 1.3
		restartSprite.name = "pause_restart"
		pauseSprite.addChild(restartSprite)
		
		let exitButton = SKTexture(imageNamed: "pauseMenu_Exit")
		let exitSprite = SKSpriteNode(texture: exitButton)
		exitSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		exitSprite.position = CGPoint(x: 0, y: -145)
		exitSprite.zPosition = 500
		exitSprite.yScale = 1.3
		exitSprite.name = "pause_exit"
		pauseSprite.addChild(exitSprite)
		
		alertLayer.addChild(pauseSprite)
		
		let spec = SKTexture(imageNamed: "spec")
		let winSpec = SKSpriteNode(texture: spec)
		winSpec.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		winSpec.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) + 150, y: CGRectGetMidY(grayedBack.frame) - 270)
		winSpec.zPosition = 315
		winSpec.xScale = 0.9
		winSpec.yScale = 0.9
		
		alertLayer.addChild(winSpec)
		
	}
	
	func saveLevelData() {
		
		let userDefaults = NSUserDefaults.standardUserDefaults();
		let myEncodedObject = NSKeyedArchiver.archivedDataWithRootObject(sections);
		
		userDefaults.setObject(myEncodedObject, forKey: "levelData")
		
	}
	
	
	func chooseWord() {
		
		wordsOfTheDay = []
		let random = Int(arc4random_uniform(UInt32(tempWords.count)))
		
		chosenWord = tempWords[random]
		tempWords.removeAtIndex(random)
		
		if storyMode {
			
			gameLevel!.storedWord = chosenWord
			sections["Level \(self.gameLevel!.section)"]![gameLevel!.level] = gameLevel!
			saveLevelData()
			
		}
		
		makeWord()
		
	}
	
	func makeWord() {
		
		var xIncrement = 0
		var startX = 0
		var newWord = Array(chosenWord.characters)
		
		switch newWord.count {
			
		case 3:
			startX = 415
		case 4:
			startX = 395
		case 5:
			startX = 365
		default:
			startX = 365
			
		}
		
		for var i = 0; i < newWord.count; i++ {
			
			let wordOfTheDay = SKLabelNode()
			wordOfTheDay.position = CGPoint(x: startX + xIncrement, y: 587)
			wordOfTheDay.zPosition = 110
			wordOfTheDay.fontSize = 75
			wordOfTheDay.name = "letter"
			wordOfTheDay.text = "\(String(newWord[i]).uppercaseString)"
			wordOfTheDay.fontName = font?.fontName
			
			if String(newWord[i]).uppercaseString == "W" {
				
				wordOfTheDay.xScale = 0.70
				wordOfTheDay.yScale = 0.98
				
			} else {
				
				wordOfTheDay.xScale = 1.0
				wordOfTheDay.yScale = 1.0
				
			}
			
			boardLayer.addChild(wordOfTheDay)
			wordsOfTheDay.append(wordOfTheDay)
			
			xIncrement += 50
			
			for var k = 0; k < defaultLetters.count; k++ {
				
				if String(newWord[i]).uppercaseString == defaultLetters[k] {
					
					usedLetters.append(letters[k])
					
				}
				
			}
			
		}
		
	}
	
	func randomFaces(chosenLetters: Letters) -> [Letters] {
		
		var tempLetters = letters
		var letterBeenUsed = false
		var catchArray : [Letters] = [chosenLetters]
		// usedLetters.append(chosenLetters)
		
		for var i = 0; i < 3; i++ {
			
			let random = Int(arc4random_uniform(UInt32(tempLetters.count - 1)))
			let letterOfTheDay = tempLetters[random]
			
			for var k = 0; k < usedLetters.count; k++ {
				
				if letterOfTheDay.letterPictures == usedLetters[k].letterPictures {
					
					print("that letter has already been used")
					letterBeenUsed = true
					break
					
					
				} else {
					
					letterBeenUsed = false
					
				}
				
			}
			
			if letterBeenUsed {
				
				i--
				tempLetters.removeAtIndex(random)
				print("we have a match")
				
			} else {
				
				catchArray.append(letterOfTheDay)
				tempLetters.removeAtIndex(random)
				
			}

		}
		
		return catchArray
		
	}
	
	func removeOldBlocks() {
		
		for var i = 0; i < columns.count; i++ {
			
			boardLayer.enumerateChildNodesWithName("done", usingBlock: { node,stop in
				
				node.removeFromParent()
				
			})
			
			boardLayer.enumerateChildNodesWithName("letter", usingBlock: { node,stop in
				
				node.removeFromParent()
				
			})
			
			boardLayer.enumerateChildNodesWithName("column\(i)", usingBlock: {
				node, stop in
				
				node.removeFromParent()
				
			})
			
		}
		
		columns = []
		
	}

	
	func loadWords() {
		
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		if !userDefaults.boolForKey("updated") {
		
			if let loadedArray = loadCustomObjectWithKey("wordArray") {
				
				words = loadedArray.words
				tempWords = words
				return
				
			}
	
		}
		
		if let stringArray = arrayFromContentsOfFileWithName("kidFriendly") {
				
				let saveWordsObj = SaveWords()
				saveWordsObj.words = stringArray
				words = stringArray
				tempWords = stringArray
				saveCustomObject(saveWordsObj)
			
				userDefaults.setBool(false, forKey: "updated")
				
		}
		
	}
	
	func placeBlox() {
		
		var xPositionInc = 80.0
		let yPositionInc = 70.0
		var startX = 268.5
		var startY = 100.0
		
		if Array(chosenWord.characters).count == 4 {
			
			xPositionInc += 26.67
			
		} else if Array(chosenWord.characters).count == 3 {
			
			startX = 322
			xPositionInc += 26.67
			
		}
		
		didYouWin = []
		
		for var i = 0; i < Array(chosenWord.characters).count; i++ {
			
			didYouWin.append(false)
			
		}
		
		for var n = 0, m = 0; n < defaultLetters.count; n++ {
			
			let letterArray = letters[n]
			let wordArray = Array(chosenWord.characters)
			
			let column = Column()
			
			if defaultLetters[n].lowercaseString == String(wordArray[m]).lowercaseString {
				
				var faces = randomFaces(letterArray)
				
				for var i = 0; i <= 5; i++ {
					
					let randomInt = Int(arc4random_uniform(UInt32(faces.count - 1))) + 1
					let textureOfRandom = faces[randomInt]
					
					let woodBlock = LetterBlock(imageNamed: textureOfRandom.letterPictures[5 - i])
					woodBlock.name = "column\(m)"
					woodBlock.tag = 5 - i
					woodBlock.letters = faces
					woodBlock.chosenLetter = randomInt
					woodBlock.xScale = 0.20
					woodBlock.yScale = 0.20
					woodBlock.anchorPoint = CGPoint(x: 0, y: 0)
					woodBlock.zPosition = 150
					
					if i != 0 {
						
						startY += yPositionInc
						
					}
					
					woodBlock.position = CGPoint(x: startX, y: 1500)

					boardLayer.addChild(woodBlock)
					
					woodBlock.runAction(SKAction.sequence([SKAction.moveTo(CGPoint(x: startX, y: startY), duration: 1)]))
					
					column.faces.append(woodBlock)
					
				}
				
				columns.append(column)
				
				startY = 100
				startX += xPositionInc
				m++
				n = -1
				
				if m == Array(chosenWord.characters).count{
					
					return
					
				}
				
			}
			
		}
		
		checkForWin()

	}
	
	func resetGame() {
	
		if firstStart {
			
			NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "startGame", object: nil))
			firstStart = false
			
		}
		
		if gamePaused {
			
			NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "togglePause", object: nil))
			
		}
		
		if !storyMode {
			
			gamePaused = false
			
		}

		usedLetters = []
		removeOldBlocks()
		chooseWord()
		placeBlox()
	
	}
	
	func checkForWin() -> Bool {
		
		var winner = false
		
		for var i = 0; i < columns.count; i++ {
			
			let column : Column = columns[i]
			if didYouWin[i] == false {
				
				didYouWin[i] = column.checkForWin()
				
				if didYouWin[i] == true {
					
					wordsOfTheDay[i].fontColor = UIColor.greenColor()
					column.faces[i].runAction(columnMatch)
					
					var count = 0
					
					for face in column.faces {
						
						face.name = "done"
						face.texture = SKTexture(imageNamed: "DONE_\(face.letters[0].letterPictures[5 - count])")
						
						count++
						
					}
					
				}
				
			}
			
		}
		
		for win in didYouWin {
			
			if win {
				
				winner = true
				
			} else {
				
				return false
				
			}
			
		}
		
		for column in columns {
			
			for face in column.faces {
				
				face.name = "done"
				
			}
			
		}
		
		return winner
		
	}
	
	func showWinMenu() {
		
		let grayedBack = SKSpriteNode(color: UIColor.blackColor(), size: self.frame.size)
		grayedBack.alpha = 0.5
		grayedBack.anchorPoint = CGPoint(x: 0, y: 0)
		alertLayer.addChild(grayedBack)
		
		let winMenu = SKTexture(imageNamed: alertImageName)
		let winSprite = SKSpriteNode(texture: winMenu)
		winSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		winSprite.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) - 35, y: CGRectGetMidY(grayedBack.frame))
		winSprite.zPosition = 310
		winSprite.xScale = 0.7
		winSprite.yScale = 0.9

		alertLayer.addChild(winSprite)
		
		let spec = SKTexture(imageNamed: "spec")
		let winSpec = SKSpriteNode(texture: spec)
		winSpec.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		winSpec.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) + 150, y: CGRectGetMidY(grayedBack.frame) - 270)
		winSpec.zPosition = 315
		winSpec.xScale = 0.9
		winSpec.yScale = 0.9
		
		alertLayer.addChild(winSpec)
		
		if storyMode {
			
			let okButton = SKTexture(imageNamed: "okButton")
			let okSprite = SKSpriteNode(texture: okButton)
			okSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			okSprite.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) + (okButton.size().width / 2) - 35, y: CGRectGetMidY(grayedBack.frame) - 165)
			okSprite.zPosition = 320
			okSprite.name = "okButton"
			alertLayer.addChild(okSprite)
			
			
		} else {
			
			let okButton = SKTexture(imageNamed: "playButton")
			let okSprite = SKSpriteNode(texture: okButton)
			okSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			okSprite.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) + (okButton.size().width / 2) - 35, y: CGRectGetMidY(grayedBack.frame) - 165)
			okSprite.zPosition = 320
			okSprite.name = "playButton"
			alertLayer.addChild(okSprite)
			
		}
		
		let menuButton = SKTexture(imageNamed: "menuButton")
		let menuSprite = SKSpriteNode(texture: menuButton)
		menuSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		menuSprite.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) - (menuButton.size().width / 2) - 35, y: CGRectGetMidY(grayedBack.frame) - 165)
		menuSprite.zPosition = 320
		menuSprite.name = "menuButton"
		alertLayer.addChild(menuSprite)
		
	}
	
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in (touches ) {
            let location = touch.locationInNode(self)
			let touchNode = self.nodeAtPoint(location)
			
			if touchNode.isKindOfClass(LetterBlock) {
			
				if let letterBlock = touchNode as? LetterBlock {
				
					if !gamePaused {
						
						if letterBlock.name != "done" {
							
							letterBlock.runAction(blockTouch)
							print(letterBlock.name)
							print(letterBlock.tag)
							print(letterBlock.letters[0].letterPictures[letterBlock.tag])
							letterBlock.changeFaces()
							
							if checkForWin() {
								
//								if !storyMode {
//									
//									gamePaused = true
//									
//								}
								
								print("you win!")
								if let emitter = SKEmitterNode(fileNamed: "Firework.sks") {
									
									emitter.position = CGPoint(x: 500, y: 450)
									emitter.zPosition = 1500
									alertLayer.addChild(emitter)
									
								}
								
								letterBlock.runAction(SKAction.sequence([winSound, SKAction.runBlock({ () -> Void in
									
									if let emitter = SKEmitterNode(fileNamed: "Firework.sks") {
										
										emitter.position = CGPoint(x: 500, y: 450)
										emitter.zPosition = 1500
										self.alertLayer.addChild(emitter)
										
									}
									
									
								}), SKAction.waitForDuration(2),SKAction.runBlock({ () -> Void in
									
									
									if self.storyMode {
										
										self.gameLevel!.isLocked = false
										sections["Level \(self.gameLevel!.section)"]![self.gameLevel!.level] = self.gameLevel!
										
										if self.gameLevel!.level + 1 < sections["Level \(self.gameLevel!.section)"]!.count {
											
											sections["Level \(self.gameLevel!.section)"]![self.gameLevel!.level + 1].isLocked = false
											
											self.alertImageName = "winMenu_Level"
											
										} else {
											
											self.gameLevel!.section++
											self.gameLevel!.level = 0
											
											if self.gameLevel!.section <= sections.count {
												
												sections["Level \(self.gameLevel!.section)"]![self.gameLevel!.level].isLocked = false
												
												self.alertImageName = "winMenu_Stage"
												
											} else {
												
												//MARK: Winner winner Game Over
												
												self.alertImageName = "winMenu_Final"
												
											}
											
										}
										
										self.saveLevelData()
										self.showWinMenu()
										
									}
									
									if !self.storyMode {
										
										self.wordCount++
										self.wordCountLabel.text = "\(self.wordCount) words"
										self.timerTime += 30
										self.resetGame()
										
									}
									
								})]))
								
								NSNotificationCenter.defaultCenter().postNotificationName("winnerwinner", object: nil)
								
							}
							
						}
						
					}
					
				}
				
			}
			
			if let name = touchNode.name {
				
				switch name {
					
				case "okButton":

					if storyMode {
						
						NSNotificationCenter.defaultCenter().postNotificationName("dismiss", object: nil)
						break
						
					}
					
					resetGame()
					alertLayer.removeAllChildren()
					
					break
				case "menuButton":
					exitToMainMenu()
					break
				case "pause_resume":
					togglePause()
					break
				case "pause_restart":
					gamePaused = false
					wordCount = 0
					timerTime = STARTCONSTANT
					wordCountLabel.text = "\(wordCount) words"
					resetGame()
					alertLayer.removeAllChildren()
					break
				case "pause_exit":
					exitToMainMenu()
					break
				case "over_facebook":
					sendFacebook()
					break
				case "over_highscore":
					showHighScores()
					break
				case "playButton":
					gamePaused = false
					resetGame()
					alertLayer.removeAllChildren()
				default:
					break
					
				}
				
			}
			
        }
		
    }
	
	func exitToMainMenu() {
		
		(UIApplication.sharedApplication().keyWindow?.rootViewController)?.dismissViewControllerAnimated(false, completion: nil)
		
	}
	
	
	
	func saveHighScore() {
		
		// Local Save
		let oldHighScore = userDefaults.integerForKey(gameMode)
		var newHighScore = 0
		
		print("Highscore: \(oldHighScore)")
		
		if wordCount > oldHighScore {
			
			newHighScore = wordCount
			userDefaults.setInteger(wordCount, forKey: gameMode)
			
		} else {
			
			newHighScore = oldHighScore
			
		}

		// Game Center Save
		if newHighScore > 0 {
			
			
			if GKLocalPlayer.localPlayer().authenticated {
				
				let highScore = GKScore(leaderboardIdentifier: gameMode)
				
				highScore.value = Int64(newHighScore)
				
				let highScoreArray: [GKScore] = [highScore]
				
				GKScore.reportScores(highScoreArray, withCompletionHandler: {(error) -> Void in
					
					if let realProblem = error {
						
						print("error: \(realProblem.localizedDescription)")
						
					}
				})
				
				
			} else {
				
				gameCenterLogin()
				
			}
			
		}

		showGameOver(newHighScore)
		
	}
	
	func gameCenterLogin() {
		
		let localPlayer = GKLocalPlayer.localPlayer()
		
		localPlayer.authenticateHandler = {(vc, error) -> Void in
			
			if (vc != nil) {
				
				UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(vc!, animated: true, completion: nil)
			
			}
				
			else {
				
				if GKLocalPlayer.localPlayer().authenticated {
					
					self.saveHighScore()
					
				}
				print((GKLocalPlayer.localPlayer().authenticated))
			
			}
		
		}
		
	}
	
	func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController)
	{
		
		gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
		
	}

	func showHighScores() {
		
		NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "gameCenter", object: nil))
		
	}
	
	func showGameOver(highScore: Int) {
		
		let grayedBack = SKSpriteNode(color: UIColor.blackColor(), size: self.frame.size)
		grayedBack.alpha = 0.5
		grayedBack.anchorPoint = CGPoint(x: 0, y: 0)
		alertLayer.addChild(grayedBack)
		
		let gameOverMenu = SKTexture(imageNamed: "GameOverMenuBack")
		let gameOverSprite = SKSpriteNode(texture: gameOverMenu)
		gameOverSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		gameOverSprite.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) - 35, y: CGRectGetMidY(grayedBack.frame))
		gameOverSprite.zPosition = 310
		gameOverSprite.xScale = 0.7
		gameOverSprite.yScale = 0.9
		alertLayer.addChild(gameOverSprite)
		
		let spec = SKTexture(imageNamed: "spec")
		let winSpec = SKSpriteNode(texture: spec)
		winSpec.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		winSpec.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) + 150, y: CGRectGetMidY(grayedBack.frame) - 270)
		winSpec.zPosition = 315
		winSpec.xScale = 0.9
		winSpec.yScale = 0.9
		
		alertLayer.addChild(winSpec)
		
		let yourScore = SKLabelNode(text: "\(wordCount)")
		yourScore.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) - 135,y: CGRectGetMidY(grayedBack.frame) + 6)
		yourScore.zPosition = 400
		alertLayer.addChild(yourScore)
		
		let highScore = SKLabelNode(text: "\(highScore)")
		highScore.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) - 135,y: CGRectGetMidY(grayedBack.frame) - 84)
		highScore.zPosition = 400
		alertLayer.addChild(highScore)

		let topRowYoffset : CGFloat = 25
		let bottomRowYoffset : CGFloat = 65.0
		
		let facebookButton = SKTexture(imageNamed: "facebookButtonLarge")
		let facebookSprite = SKSpriteNode(texture: facebookButton)
		facebookSprite.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) + 75,y: CGRectGetMidY(grayedBack.frame) - bottomRowYoffset)
		facebookSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		facebookSprite.xScale = 0.7
		facebookSprite.yScale = 0.7
		facebookSprite.name = "over_facebook"
		facebookSprite.zPosition = 400
		alertLayer.addChild(facebookSprite)
		
		let highScoreButton = SKTexture(imageNamed: "highScoreLarge")
		let highScoreSprite = SKSpriteNode(texture: highScoreButton)
		highScoreSprite.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) - 20,y: CGRectGetMidY(grayedBack.frame) - bottomRowYoffset)
		highScoreSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		highScoreSprite.xScale = 0.7
		highScoreSprite.yScale = 0.7
		highScoreSprite.name = "over_highscore"
		highScoreSprite.zPosition = 400
		alertLayer.addChild(highScoreSprite)
		
		let homeButton = SKTexture(imageNamed: "homeButton")
		let homeSprite = SKSpriteNode(texture: homeButton)
		homeSprite.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) - 20,y: CGRectGetMidY(grayedBack.frame) + topRowYoffset)
		homeSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		homeSprite.xScale = 0.7
		homeSprite.yScale = 0.7
		homeSprite.name = "menuButton"
		homeSprite.zPosition = 400
		alertLayer.addChild(homeSprite)
		
		let replayButton = SKTexture(imageNamed: "replayButton")
		let replaySprite = SKSpriteNode(texture: replayButton)
		replaySprite.position = CGPoint(x: CGRectGetMidX(grayedBack.frame) + 75,y: CGRectGetMidY(grayedBack.frame) + topRowYoffset)
		replaySprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		replaySprite.xScale = 0.7
		replaySprite.yScale = 0.7
		replaySprite.name = "pause_restart"
		replaySprite.zPosition = 400
		alertLayer.addChild(replaySprite)
		
	}
	
	func sendFacebook() {
	
		let facebookMessage = FacebookMessage()
		facebookMessage.myInt = wordCount
		
		let transmission : [String : AnyObject] = ["data" : facebookMessage]
		
		NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "facebookMessage", object: nil, userInfo: transmission))
		
	}
	
	func gameOver() {
		
		saveHighScore()
		gamePaused = true
		
	}
	
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
		let timeSinceLast = currentTime - lastUpdateTime
		
		// If not in story mode run timer.
		if !storyMode {
			
			if !gamePaused {
				
				if timerTime <= 0 {
					
					gameOver()
					return
					
				}
				
				if timeSinceLast > 1.0 {
					
					timerTime--
					timerLabel.text = "\(timerTime)"
					lastUpdateTime = currentTime
					
				}
				
			}
			
		}
		
    }
	
}
