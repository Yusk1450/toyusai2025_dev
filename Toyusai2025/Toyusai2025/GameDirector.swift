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

// 部屋の種別
enum RoomType: Int
{
	case A
	case B
}

enum OSCAddress: String
{
	case MathDeviceRoomA = "/math/to/app/rooma"
	case MathDeviceRoomB = "/math/to/app/roomb"
	case MathMovieStart = "/math/movie/start"
	case InformaticsDeviceSend = "/rfid_confirm"
	case InformaticsDeviceReceive = "/uuid"
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
	let ip = "192.168.0.199"
	// サーバURL
	var url:String!
	
	// OSCポート番号
	let port:UInt16 = 33333
	private let oscServer:OSCUdpServer!
	
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
		self.oscServer = OSCUdpServer(port: self.port)
		
		super.init()
		self.oscServer.delegate = self
		
		do
		{
			try self.oscServer.startListening()
		}
		catch
		{
			print(error.localizedDescription)
		}
		
		self.url = "http://\(self.ip):8888/server"
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
//			self.sendSimpleOSCMessage(ip: ip, address: "/light_off")
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
			
			if let viewController = self.currentViewController
			{
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				if let timeoverViewController = storyboard.instantiateViewController(withIdentifier: "TimeoverEndViewController") as? TimeoverEndViewController
				{
					viewController.present(timeoverViewController, animated: true, completion: nil)
				}
			}
			
			return
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
				
//					print(res.data)
					
					if let data = res.data
					{
						let json = JSON(data)
						
//						print(json)
						
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
	
	/* ----------------------------------------------------
	 * シーンの切り替え
	 ----------------------------------------------------*/
	func changeScene(scene:BaseScene)
	{
		self.currentScene?.stop(viewController: self.currentViewController)
		self.currentScene?.delegate = nil
		
		self.currentScene = scene
//		self.currentScene?.delegate = self
		self.currentScene?.start(viewController: self.currentViewController)
	}
	
	/* ----------------------------------------------------
	 * OSCの送信
	 ----------------------------------------------------*/
	func sendSimpleOSCMessage(ip:String, address:String)
	{
		let client = OSCUdpClient(host: ip, port: self.port)
		if let message = try? OSCMessage(with: address, arguments: [])
		{
			if let _ = try? client.send(message)
			{
			}
		}
	}
}

extension GameDirector: OSCUdpServerDelegate
{
	func server(_ server: OSCUdpServer, didReceivePacket packet: any OSCPacket, fromHost host: String, port: UInt16)
	{
		if let message = packet as? OSCMessage
		{
			print(message.addressPattern.fullPath)
			
			// 数学デバイス（部屋A）
			if (message.addressPattern.fullPath == OSCAddress.MathDeviceRoomA.rawValue)
			{
				if let scene = self.currentScene as? MathScene
				{
					// 自分が部屋Aのとき
					if (self.roomType == .A)
					{
						scene.movePointH()
					}
					else if (self.roomType == .B)
					{
						scene.movePointH()
					}
				}
			}
			// 数学デバイス（部屋B）
			else if (message.addressPattern.fullPath == OSCAddress.MathDeviceRoomB.rawValue)
			{
				if let scene = self.currentScene as? MathScene
				{
					// 自分が部屋Aのとき
					if (self.roomType == .A)
					{
						scene.movePointM()
					}
					else if (self.roomType == .B)
					{
						scene.movePointM()
					}
				}
			}
			// 動画を再生する
			else if (message.addressPattern.fullPath == OSCAddress.MathMovieStart.rawValue)
			{
				if let scene = self.currentScene as? MathScene
				{
					scene.playMovie()
				}
			}
			// 情報デバイス
			else if (message.addressPattern.fullPath == OSCAddress.InformaticsDeviceReceive.rawValue)
			{
				print(message.arguments)
				
				if let uuid1 = message.arguments[0] as? String,
				   let uuid2 = message.arguments[1] as? String,
				   let uuid3 = message.arguments[2] as? String
				{
					if let scene = self.currentScene as? InformaticsScene
					{
						scene.answerMarks(uuid1: uuid1, uuid2: uuid2, uuid3: uuid3)
					}
				}
			}
		}
	}
	
	func server(_ server: OSCUdpServer, socketDidCloseWithError error: (any Error)?)
	{
	}
	
	func server(_ server: OSCUdpServer, didReadData data: Data, with error: any Error)
	{
	}
}
