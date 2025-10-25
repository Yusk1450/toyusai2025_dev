//
//  BadEndViewController.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/25.
//

import UIKit

class BadEndViewController: UIViewController
{

	@IBOutlet weak var lbl1: UILabel!
	@IBOutlet weak var lbl2: UILabel!
	@IBOutlet weak var lineImgView: UIImageView!
	@IBOutlet weak var lbl3: UILabel!
	@IBOutlet weak var bgImgView: UIImageView!
	
	@IBOutlet weak var gameoverImgView: UIImageView!
	
	override func viewDidLoad()
	{
        super.viewDidLoad()


		
    }
	
	override func viewDidAppear(_ animated: Bool)
	{
		super.viewDidAppear(animated)

		UIView.animate(withDuration: 2.0, delay: 4.0) {
			
			self.lbl1.frame.origin.x -= 150.0
			self.lbl2.frame.origin.x += 100.0
			self.lineImgView.frame.origin.x += 100.0
			
		} completion: { isCompleted in
			
			if (isCompleted)
			{
				UIView.animate(withDuration: 2.0, delay: 0.0) {
					
					self.lbl3.alpha = 1.0
					
				} completion: { isCompleted in
					
					if (isCompleted)
					{
						self.bgImgView.isHidden = true

						if let text = self.lbl3.text
						{
							let attributedString = NSMutableAttributedString(string: text)
							
							if let range = text.range(of: "コタエ") {
								let nsRange = NSRange(range, in: text)
								attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
							}
							if let range = text.range(of: "を") {
								let nsRange = NSRange(range, in: text)
								attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: nsRange)
							}
							self.lbl3.attributedText = attributedString
						}
						
						Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
							
							self.gameoverImgView.isHidden = false
							
						}

					}
					
				}
			}
		}

	}
    


}
