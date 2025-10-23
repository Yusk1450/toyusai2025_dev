//
//  GameDirector.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/22.
//

import UIKit
import OSCKit
import Alamofire
import SwiftyJSON

enum RoomType: Int
{
	case A
	case B
}

protocol GameDirectorDelegate: AnyObject
{
	func gameDirectorDidChangeNextScript(gameDirector:GameDirector, script:String)
	func gameDirectorDidUpdate(gameDirector:GameDirector)
}

class GameDirector: NSObject
{
	static let shared = GameDirector()
	
	var delegate:GameDirectorDelegate?

	// 部屋種別
	var roomType:RoomType = .A
	
	// サーバIP
	let ip = "192.168.0.33"
	let port:UInt16 = 33333
	
	var url:String!
	
	let lightIPAddress = [
		"192.168.0.207",
		"192.168.0.208",
		"192.168.0.209",
		"192.168.0.210",
		"192.168.0.211",
		"192.168.0.212"
	]
	
	// 残り時間
	var remainGameTime = 600
	var gameTimer:Timer?
	
	var currentViewController:UIViewController?
	
	// 現在のシーンクラス
	var currentScene:BaseScene?
	// ギミッククリアフラグ
	var gimmickFlags = [false, false, false, false, false, false, false, false, false, false]
	
	override init()
	{
		super.init()
		
		self.url = "http://\(self.ip):8888/WORKS/NBU/toyusai2025_dev/server"
	}
	
	/* ----------------------------------------------------
	 * ゲームを開始する
	-----------------------------------------------------*/
	func startGame()
	{
		self.remainGameTime = 600
		
		// すべての誘導灯をOFFにする
//		for ip in self.lightIPAddress
//		{
//			var client = OSCUdpClient(host: ip, port: self.port)
//			if let message = try? OSCMessage(with: "/light_off", arguments: [])
//			{
//				if let _ = try? client.send(message)
//				{
//				}
//			}
//		}
		
		self.gameTimer = Timer.scheduledTimer(timeInterval: 1.0,
											  target: self,
											  selector: #selector(self.updateGameStatus(timer:)),
											  userInfo: nil,
											  repeats: true)
	}
	
	/* ----------------------------------------------------
	 * ゲームループ
	-----------------------------------------------------*/
	@objc func updateGameStatus(timer:Timer)
	{
		self.remainGameTime -= 1
				
		// 時間切れ
		if (self.remainGameTime < 0)
		{
			self.gameTimer?.invalidate()
		}
		
		// サーバのフラグを確認する
		self.updateServerFlag()
		
		self.currentScene?.update(viewController: self.currentViewController)
		self.delegate?.gameDirectorDidUpdate(gameDirector: self)
	}

	func updateServerFlag()
	{
		if let url = self.url
		{
			AF.request("\(url)/flag",
					   method: .get,
					   parameters: nil,
					   encoding: URLEncoding.default,
					   headers: nil
			)
				.responseJSON { res in
				
					print(res.data)
					
					if let data = res.data
					{
						let json = JSON(data)
						
						print(json)
						
						for i in stride(from: 0, to: self.gimmickFlags.count, by: 1)
						{
							self.gimmickFlags[i] = json[i].boolValue
						}
					}

			}
		}
	}
	
	func sendFlagToServer(flagIndex:Int)
	{
		if let url = self.url
		{
			AF.request("\(url)/flag",
					   method: .post,
					   parameters: ["flag_id": flagIndex],
					   encoding: URLEncoding.default,
					   headers: nil
			)
				.responseJSON { res in
			}
		}
	}
}
