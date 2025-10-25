//
//  ArtBViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/21.
//

import UIKit

class ArtBViewController: BaseViewController
{
    @IBOutlet weak var HourTextField: UITextField!
    @IBOutlet weak var MinuteTextField: UITextField!
    
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
		   let hourText = HourTextField.text,
		   let minuteText = MinuteTextField.text
		{
			if (scene.checkAnswer("\(hourText)\(minuteText)"))
			{
			}
		}
    }
    

}
