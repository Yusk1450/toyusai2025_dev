//
//  JapaneseViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/22.
//

import UIKit

class JapaneseViewController: BaseViewController
{
	@IBOutlet weak var TextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

		let director = GameDirector.shared
		director.currentViewController = self
		director.changeScene(scene: JapaneseScene())
    }
    
    @IBAction func AnswerBtnAction(_ sender: Any)
    {
		let director = GameDirector.shared
		if let scene = director.currentScene as? JapaneseScene,
		   let text = self.TextField.text
		{
			scene.checkAnswer(answer: text)
		}
    }
    
}
