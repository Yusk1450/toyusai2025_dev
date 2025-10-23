//
//  ViewController.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/14.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var startButton: UIButton!
    
	var waitingTimer: Timer?
	
	override func viewDidLoad()
    {
		super.viewDidLoad()
        
		// 線の太さ
        startButton.layer.borderWidth = 2
		// 線の色
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.cornerRadius = 30
	}
	
	@IBAction func startBtnAction(_ sender: Any)
	{
		self.startButton.isHidden = true
		
		let director = GameDirector.shared
		director.sendFlagToServer(flagIndex: director.roomType == .A ? 0 : 1)
				
		self.waitingTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
			
			director.updateServerFlag()
			
			// 両方のスタートフラグが立った場合にゲームスタート
			if (director.gimmickFlags[0] && director.gimmickFlags[1])
			{
				director.startGame()
				self.waitingTimer?.invalidate()
				
				self.performSegue(withIdentifier: "toStart", sender: nil)
			}
		}
		
	}
	


}

