//
//  BaseScene.swift
//  Toyusai2024
//
//  Created by ISHIGO Yusuke on 2024/10/17.
//

import UIKit
import AVFoundation

protocol GameSceneDelegate: AnyObject
{
	func gameSceneDidStart(scene:BaseScene)
}

class BaseScene: NSObject
{
	var scenario = [String]()
	
	var audioPlayer:AVAudioPlayer?
	var delegate:GameSceneDelegate?
	
	func start(viewController:UIViewController?)
	{
		let path = Bundle.main.path(forResource: "sound", ofType: "mp3")
		let url = URL(fileURLWithPath: path!)
		self.audioPlayer = try? AVAudioPlayer(contentsOf: url)
		self.audioPlayer?.prepareToPlay()
		
		self.delegate?.gameSceneDidStart(scene: self)
	}
	
	func update(viewController:UIViewController?)
	{
	}
	
	func stop(viewController:UIViewController?)
	{
	}
	
	func playNextSound()
	{
		self.audioPlayer?.play()
	}
}
