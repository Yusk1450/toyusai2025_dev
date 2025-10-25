//
//  ArtAViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/21.
//

import UIKit

class ArtAViewController: BaseViewController
{
    @IBOutlet weak var MonthTextField: UITextField!
    @IBOutlet weak var DayTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

		let director = GameDirector.shared
		director.currentViewController = self
		director.changeScene(scene: ArtScene())
    }

    @IBAction func AnswerBtnAction(_ sender: Any)
	{
		let director = GameDirector.shared
		if let scene = director.currentScene as? ArtScene,
		   let monthText = MonthTextField.text,
		   let dayText = DayTextField.text
		{
			if (scene.checkAnswer("\(monthText)\(dayText)"))
			{
			}
		}
    }
}
