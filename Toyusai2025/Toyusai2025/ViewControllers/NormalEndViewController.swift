//
//  NormalEndViewController.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/24.
//

import UIKit

class NormalEndViewController: UIViewController
{
	let imageNames = ["NormalEndBg_2", "NormalEndBg_3", "NormalEndBg_4", "timeoverbg_2"]
	var imageIndex = 0
	
	@IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad()
	{
        super.viewDidLoad()

    }

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		if (self.imageIndex < self.imageNames.count)
		{
			self.imageView.image = UIImage(named: self.imageNames[self.imageIndex])
			self.imageIndex += 1
		}
	}

}
