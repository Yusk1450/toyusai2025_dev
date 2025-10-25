//
//  TrueEnd2ViewController.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/26.
//

import UIKit

class TrueEnd2ViewController: UIViewController
{
	@IBOutlet weak var creditImageView: UIImageView!
	@IBOutlet weak var messageImageView: UIImageView!
	
	
	var timer:Timer?
	
    override func viewDidLoad()
	{
        super.viewDidLoad()

		self.creditImageView.frame.origin.y = self.creditImageView.frame.height
		
		self.timer = Timer.scheduledTimer(timeInterval: 0.01,
										  target: self,
										  selector: #selector(self.timerAction),
										  userInfo: nil,
										  repeats: true)
    }
	
	@objc func timerAction()
	{
		self.creditImageView.frame.origin.y -= 0.4
		
		if (self.creditImageView.frame.origin.y <= -900)
		{
			self.timer?.invalidate()
			
			UIView.animate(withDuration: 5.0) {
				self.messageImageView.alpha = 1.0
			}
		}
	}
}
