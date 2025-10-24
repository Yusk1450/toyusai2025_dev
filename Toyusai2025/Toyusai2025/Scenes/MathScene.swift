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
	
	override func start(viewController: UIViewController?)
	{
	}
	
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
				viewController.play()
				self.isMoviePlaying = true
			}
		}
		else
		{
			self.count += 1
			
			viewController.SpeedCount.text = self.count.description
		}
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
				viewController.answerBtn.isHidden = false
				GameDirector.shared.sendFlagToServer(flagIndex: 2)
			}
		}
	}
	
	func movePointM()
	{
		if let viewController = GameDirector.shared.currentViewController as? MathViewController
		{
			viewController.PointM.center.x += 10
			viewController.PointMLbl.center.x += 10
		}
	}
}
