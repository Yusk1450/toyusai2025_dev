//
//  BadEndTimeoverViewController.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/25.
//

import UIKit

class TimeoverEndViewController: UIViewController
{
	@IBOutlet weak var imageView: UIImageView!
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
    }
    
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		self.imageView.image = UIImage(named: "timeoverbg_2")
	}

}
