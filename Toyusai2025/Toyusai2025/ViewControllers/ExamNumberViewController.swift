//
//  ExamNumberViewController.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/25.
//

import UIKit

class ExamNumberViewController: BaseViewController
{
	@IBOutlet weak var examNumberTextField: UITextField!
	@IBOutlet weak var messageImageView: UIImageView!
	
	
    override func viewDidLoad()
	{
        super.viewDidLoad()

    }

	override func textFieldShouldReturn(_ textField: UITextField) -> Bool
	{
		super.textFieldShouldReturn(textField)
		
		if let text = textField.text
		{
			if (text == "1450")
			{
				let director = GameDirector.shared
				if let scene = director.currentScene as? JapaneseScene
				{
					scene.isMoved = true
				}
				director.sendFlagToServer(flagIndex: 9)
				self.performSegue(withIdentifier: "toEnd", sender: nil)
			}
			else
			{
				self.messageImageView.image = UIImage(named: "ExamNumberErrorMessage")
			}
		}
		
		return true
	}
	
}
