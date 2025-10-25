//
//  TrueEndViewController.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/25.
//

import UIKit

class TrueEndViewController: UIViewController
{
	let imageNames = ["TrueEndBg_2", "TrueEndBg_3"]
	var imageIndex = 0
	
	@IBOutlet weak var imageView: UIImageView!
	
	override func viewDidLoad()
	{
        super.viewDidLoad()

    }
    
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		if (self.imageIndex >= self.imageNames.count)
		{
			self.performSegue(withIdentifier: "toTrue2", sender: nil)
			return
		}
		
		self.imageView.image = UIImage(named: self.imageNames[self.imageIndex])
		self.imageIndex += 1
		
		
	}

}
