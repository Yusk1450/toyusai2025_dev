//
//  InformaticsScene.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/24.
//

import UIKit
import OSCKit

class InformaticsScene: BaseScene
{
	/* -------------------------------------------------
	 * シーン開始
	 -------------------------------------------------*/
	override func start(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.208", address: "/light_on")
	}
	
	/* -------------------------------------------------
	 * シーン中
	 -------------------------------------------------*/
	override func update(viewController: UIViewController?)
	{
		// 情報のクリアフラグを確認する
		if (GameDirector.shared.gimmickFlags[3])
		{
			if GameDirector.shared.currentViewController is InformationAViewController ||
			   GameDirector.shared.currentViewController is InformationBViewController
			{
				viewController?.performSegue(withIdentifier: "toEnglish", sender: nil)
			}
		}
	}
	
	/* -------------------------------------------------
	 * シーン終了
	 -------------------------------------------------*/
	override func stop(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.208", address: "/light_off")
	}
	
	func checkMarks()
	{
		print("checkMarks")
		
		// RFIDデバイスに送信する
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.204", address: OSCAddress.InformaticsDeviceSend.rawValue)
	}
	
	func answerMarks(uuid1: String, uuid2: String, uuid3: String)
	{
		// 正解
		if (uuid1 == "149112553" && uuid2 == "15316595" && uuid3 == "20199165")
		{
			let director = GameDirector.shared
			GameDirector.shared.sendFlagToServer(flagIndex: 3)
		}
		else
		{
			// TODO: ハズレの音を再生する
		}
	}

}
