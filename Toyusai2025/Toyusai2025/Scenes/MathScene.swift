//
//  MathScene.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/23.
//

import UIKit

class MathScene: BaseScene
{
	var count = 0
	var isMoviePlaying = false
	
	/* -------------------------------------------------
	 * シーン開始
	 -------------------------------------------------*/
	override func start(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.207", address: "/light_on")
	}
	
	/* -------------------------------------------------
	 * シーン中
	 -------------------------------------------------*/
	override func update(viewController: UIViewController?)
	{
		guard let viewController = viewController as? MathViewController else
		{
			return
		}
		
		// 数学のクリアフラグを確認する
		if (GameDirector.shared.gimmickFlags[2])
		{
			if (!isMoviePlaying)
			{
				GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.201", address: OSCAddress.MathMovieStart.rawValue)
				self.playMovie()
				self.isMoviePlaying = true
			}
		}
		else
		{
			self.count += 1
			
			viewController.SpeedCount.text = self.count.description
		}
	}
	
	func playMovie()
	{
		let director = GameDirector.shared
		guard let viewController = director.currentViewController as? MathViewController else
		{
			return
		}
		viewController.play()
	}
	
	/* -------------------------------------------------
	 * シーン終了
	 -------------------------------------------------*/
	override func stop(viewController: UIViewController?)
	{
		GameDirector.shared.sendSimpleOSCMessage(ip: "192.168.0.207", address: "/light_off")
	}
	
	func movePointH()
	{
		if let viewController = GameDirector.shared.currentViewController as? MathViewController
		{
			if (viewController.PointH.center.x < viewController.PointM.center.x)
			{
				viewController.PointH.center.x += 10
				viewController.PointHLbl.center.x += 10
			}
			else
			{
				// 数学クリア
				GameDirector.shared.sendFlagToServer(flagIndex: 2)
			}
		}
	}
	
	func movePointM()
	{
		if let viewController = GameDirector.shared.currentViewController as? MathViewController
		{
			if (viewController.PointM.center.x <= 887)
			{
				viewController.PointM.center.x += 10
				viewController.PointMLbl.center.x += 10
			}
		}
	}
}
