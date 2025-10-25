//
//  ViewController.swift
//  mirrorapp
//
//  Created by ISHIGO Yusuke on 2025/10/21.
//

import UIKit
import OSCKit
import AVFoundation

class ViewController: UIViewController
{
	let port:UInt16 = 33333
	var oscServer:OSCUdpServer!
	
	@IBOutlet weak var playerView: PlayerView!
	
	var player = AVPlayer()
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		UIScreen.main.brightness = 0.0
		
		self.oscServer = OSCUdpServer(port: self.port)
		self.oscServer.delegate = self
		
		do
		{
			try self.oscServer.startListening()
		}
		catch
		{
			print(error.localizedDescription)
		}
	}

	func getPlayerItem() -> AVPlayerItem?
	{
		guard let url = Bundle.main.url(forResource: "INK_main", withExtension: "mp4") else
		{
			print("URL is nil")
			return nil
		}
		
		return AVPlayerItem(url: url)
	}
	
	func play()
	{
		if let item = self.getPlayerItem()
		{
			self.playerView.player = AVPlayer(playerItem: item)
		}
		self.playerView.player?.play()
	}
	
	override var prefersStatusBarHidden: Bool
	{
		return true
	}
}

extension ViewController: OSCUdpServerDelegate
{
	func server( _ server: OSCUdpServer, didReceivePacket packet: any OSCPacket, fromHost host: String, port: UInt16)
		{
			if let message = packet as? OSCMessage
			{
				print(message.addressPattern.fullPath)

				if (message.addressPattern.fullPath == "/app/magicmirror")
				{
					UIScreen.main.brightness = 1.0
					self.playerView.isHidden = false
					self.play()
				}
				else if (message.addressPattern.fullPath == "/reset")
				{
					UIScreen.main.brightness = 0.0
					self.playerView.isHidden = true
				}
			}
		}

	
	func server(_ server: OSCUdpServer, socketDidCloseWithError error: (any Error)?)
	{
	}
	
	func server(_ server: OSCUdpServer, didReadData data: Data, with error: any Error)
	{
	}
	
}
