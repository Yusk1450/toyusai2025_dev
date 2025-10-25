//
//  EnglishScene.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/24.
//

import UIKit

class EnglishScene: BaseScene
{
	override func start(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.209", address: "/light_on")
	}
	
	override func update(viewController: UIViewController?)
	{
		// 英語のクリアフラグを確認する
		if (GameDirector.shared.gimmickFlags[4])
		{
			if GameDirector.shared.currentViewController is EnglishAViewController ||
			   GameDirector.shared.currentViewController is EnglishBViewController
			{
				viewController?.performSegue(withIdentifier: "toArt", sender: nil)
			}
		}
	}
	
	override func stop(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.209", address: "/light_off")
	}
	
	func checkAnswer(_ answer: String) -> Bool
	{
		// マジックミラーにOSCを送信する
		let cleanedText = answer.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)
		if (cleanedText == "かがみのなか")
		{
			// マジックミラーにOSCを送信する
			GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.210", address: "/light_on")

			Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
				GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.205", address: "/app/magicmirror")
				GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.206", address: "/app/magicmirror")
			}
			
			GameDirector.shared.sendFlagToServer(flagIndex: 4)
			
			Timer.scheduledTimer(withTimeInterval: 25.0, repeats: false) { timer in
				print("/light_off")
				GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.210", address: "/light_off")
			}
			
			return true
		}

		return false
	}
}
