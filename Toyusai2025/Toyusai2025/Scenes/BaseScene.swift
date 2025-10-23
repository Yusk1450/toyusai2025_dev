//
//  BaseScene.swift
//  Toyusai2024
//
//  Created by ISHIGO Yusuke on 2024/10/17.
//

import UIKit

protocol GameSceneDelegate: AnyObject
{
	func gameSceneDidStart(scene:BaseScene)
}

class BaseScene: NSObject
{
	var scenario = [String]()
	
	var delegate:GameSceneDelegate?
	
	func start(viewController:UIViewController?)
	{
		self.delegate?.gameSceneDidStart(scene: self)
	}
	
	func update(viewController:UIViewController?)
	{
	}
	
	func stop(viewController:UIViewController?)
	{
	}
}
