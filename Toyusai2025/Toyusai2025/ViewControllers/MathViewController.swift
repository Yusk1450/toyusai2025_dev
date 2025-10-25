//
//  MathViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/21.
//

import UIKit
import AVFoundation

class MathViewController: BaseViewController
{
    @IBOutlet weak var PointH: UIView!
    @IBOutlet weak var PointM: UIView!
    
    @IBOutlet weak var PointHLbl: CustomLabel!
    @IBOutlet weak var PointMLbl: CustomLabel!
    
    @IBOutlet weak var SpeedCount: CustomLabel!
	
	@IBOutlet weak var playerView: PlayerView!
	
	@IBOutlet weak var answerBtn: CustomButton!
	
    override func viewDidLoad()
    {
        super.viewDidLoad()
		
		let director = GameDirector.shared
		director.changeScene(scene: MathScene())
		
		NotificationCenter.default.addObserver(self,
											   selector: #selector(self.playerDidFinishPlaying),
											   name: .AVPlayerItemDidPlayToEndTime,
											   object: nil)
    }
	
	override func viewDidDisappear(_ animated: Bool)
	{
		super.viewDidDisappear(animated)
		
		NotificationCenter.default.removeObserver(self)
	}
    
    @IBAction func answerBtnAction(_ sender: Any)
    {
		let director = GameDirector.shared
		if (director.roomType == .A)
		{
			self.performSegue(withIdentifier: "toA", sender: nil)
		}
		else if (director.roomType == .B)
		{
			self.performSegue(withIdentifier: "toB", sender: nil)
		}
    }
	
	@objc func playerDidFinishPlaying()
	{
		self.playerView.isHidden = true
		self.answerBtn.isHidden = false
	}
    
	func getPlayerItem() -> AVPlayerItem?
	{
		guard let url = Bundle.main.url(forResource: "mathmovie", withExtension: "mp4") else
		{
			print("URL is nil")
			return nil
		}
		
		return AVPlayerItem(url: url)
	}
	
	func play()
	{
		self.playerView.isHidden = false
		
		if let item = self.getPlayerItem()
		{
			self.playerView.player = AVPlayer(playerItem: item)
		}
		self.playerView.player?.play()
	}

}
