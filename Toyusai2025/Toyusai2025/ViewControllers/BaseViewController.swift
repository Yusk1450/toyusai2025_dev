//
//  BaseViewController.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/23.
//

import UIKit
import AVFoundation

class BaseViewController: UIViewController, UITextFieldDelegate
{
	@IBOutlet weak var timeCountLbl: UILabel!
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		// キーボード表示
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShowNotification),name: UIResponder.keyboardWillShowNotification,object: nil)

		// キーボード非表示
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
		NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHideNotification),name: UIResponder.keyboardWillHideNotification,object: nil)
		
		let director = GameDirector.shared
		director.currentViewController = self
		director.delegate = self
	}
	
//	override func viewWillDisappear(_ animated: Bool)
//	{
//		super.viewWillDisappear(animated)
//
//		GameDirector.shared.delegate = nil
//	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		textField.resignFirstResponder()
		return true
	}
	
	@objc func keyboardWillShowNotification(notification:NSNotification)
	{
		guard let userInfo = notification.userInfo else { return }
		guard let isLocalUserInfoKey = userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber else { return }
		
		if (!isLocalUserInfoKey.boolValue) { return }
		
		let transform = CGAffineTransform(translationX: 0, y: -300)
		self.view.transform = transform
	}
	
	@objc func keyboardWillHideNotification(notification:NSNotification)
	{
		guard let userInfo = notification.userInfo else { return }
		guard let isLocalUserInfoKey = userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber else { return }

		if (!isLocalUserInfoKey.boolValue) { return }
		
		self.view.transform = CGAffineTransform.identity
	}
}

extension BaseViewController : GameDirectorDelegate
{
	func gameDirectorDidChangeNextScript(gameDirector: GameDirector, script: String)
	{
	}
	
	func gameDirectorDidUpdate(gameDirector: GameDirector)
	{
		self.timeCountLbl.text = GameDirector.shared.remainGameTime.description
		print(GameDirector.shared.remainGameTime.description)
	}
}
