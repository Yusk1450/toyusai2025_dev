//
//  JapaneseScene.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/25.
//

import UIKit

class JapaneseScene: BaseScene
{
	var isMoved = false
	
	override func start(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.212", address: "/light_on")
	}
	
	override func update(viewController: UIViewController?)
	{
		if (!self.isMoved)
		{
			if (GameDirector.shared.gimmickFlags[7])
			{
				viewController?.performSegue(withIdentifier: "toNormal", sender: nil)
			}
			else if (GameDirector.shared.gimmickFlags[8])
			{
				viewController?.performSegue(withIdentifier: "toBad", sender: nil)
			}
			else if (GameDirector.shared.gimmickFlags[9])
			{
				viewController?.performSegue(withIdentifier: "toTrue", sender: nil)
			}
		}
	}
	
	override func stop(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.212", address: "/light_off")
	}
	
	func checkAnswer(answer: String)
	{
		let director = GameDirector.shared
		
		if (answer == "N大学に入学したい")
		{
			self.isMoved = true
			GameDirector.shared.sendFlagToServer(flagIndex: 7)
			director.currentViewController?.performSegue(withIdentifier: "toNormal", sender: nil)
		}
		else
		{
			self.isMoved = true
			GameDirector.shared.sendFlagToServer(flagIndex: 8)
			director.currentViewController?.performSegue(withIdentifier: "toBad", sender: nil)
		}
	}
}
