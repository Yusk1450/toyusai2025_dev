//
//  InformationViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/21.
//

import UIKit

class InformationAViewController: BaseViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

		let director = GameDirector.shared
		director.currentViewController = self
		director.changeScene(scene: InformaticsScene())
    }
    

}
