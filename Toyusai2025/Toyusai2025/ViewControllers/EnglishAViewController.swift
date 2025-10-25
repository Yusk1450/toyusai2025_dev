//
//  EnglishAViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/21.
//

import UIKit

class EnglishAViewController: BaseViewController
{
    @IBOutlet weak var TextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

		let director = GameDirector.shared
		director.currentViewController = self
		director.changeScene(scene: EnglishScene())
    }
    
    @IBAction func AnswerBtnAction(_ sender: Any)
    {
		let director = GameDirector.shared
		if let scene = director.currentScene as? EnglishScene,
		   let text = TextField.text
		{
			if (scene.checkAnswer(text))
			{
			}
		}
    }
    
    
}
