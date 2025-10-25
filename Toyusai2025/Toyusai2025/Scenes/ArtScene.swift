//
//  ArtScene.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/24.
//

import UIKit

class ArtScene: BaseScene
{
	override func start(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.211", address: "/light_on")
	}
	
	override func update(viewController: UIViewController?)
	{
		// 美術のクリアフラグを確認する
		if (GameDirector.shared.gimmickFlags[5] && GameDirector.shared.gimmickFlags[6])
		{
			if GameDirector.shared.currentViewController is ArtAViewController ||
			   GameDirector.shared.currentViewController is ArtBViewController
			{
				viewController?.performSegue(withIdentifier: "toJapanese", sender: nil)
			}
		}
	}
	
	override func stop(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.211", address: "/light_off")
	}
	
	func checkAnswer(_ answer: String) -> Bool
	{
		let cleanedText = answer.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)
		
		let director = GameDirector.shared
		
		if (director.roomType == .A)
		{
			if (cleanedText == "212")
			{
				GameDirector.shared.sendFlagToServer(flagIndex: 5)
				return true
			}
		}
		else if (director.roomType == .B)
		{
			if (cleanedText == "811")
			{
				GameDirector.shared.sendFlagToServer(flagIndex: 6)
				return true
			}
		}

		return false
	}
}
