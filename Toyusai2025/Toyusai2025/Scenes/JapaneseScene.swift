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
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				if let viewController = storyboard.instantiateViewController(withIdentifier: "NormalEndViewController") as? NormalEndViewController
				{
					GameDirector.shared.currentViewController?.present(viewController, animated: true, completion: nil)
				}
			}
			else if (GameDirector.shared.gimmickFlags[8])
			{
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				if let viewController = storyboard.instantiateViewController(withIdentifier: "BadEndViewController") as? BadEndViewController
				{
					GameDirector.shared.currentViewController?.present(viewController, animated: true, completion: nil)
				}
			}
			else if (GameDirector.shared.gimmickFlags[9])
			{
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				if let viewController = storyboard.instantiateViewController(withIdentifier: "TrueEndViewController") as? TrueEndViewController
				{
					GameDirector.shared.currentViewController?.present(viewController, animated: true, completion: nil)
				}

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

			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			if let viewController = storyboard.instantiateViewController(withIdentifier: "NormalEndViewController") as? NormalEndViewController
			{
				director.currentViewController?.present(viewController, animated: true, completion: nil)
			}
		}
		else
		{
			self.isMoved = true
			GameDirector.shared.sendFlagToServer(flagIndex: 8)

			let storyboard = UIStoryboard(name: "Main", bundle: nil)
			if let viewController = storyboard.instantiateViewController(withIdentifier: "BadEndViewController") as? BadEndViewController
			{
				director.currentViewController?.present(viewController, animated: true, completion: nil)
			}
		}
	}
}
