//
//  JapaneseScene.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/25.
//

import UIKit

class JapaneseScene: BaseScene
{
	override func start(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.212", address: "/light_on")
	}
	
	override func update(viewController: UIViewController?)
	{
	}
	
	override func stop(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.212", address: "/light_off")
	}
	
	func checkAnswer(answer: String)
	{
		if (answer == "N大学に入学したい")
		{
			
		}
		else
		{
			
		}
	}
}
