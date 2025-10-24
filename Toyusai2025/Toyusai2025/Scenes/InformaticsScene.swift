//
//  InformaticsScene.swift
//  Toyusai2025
//
//  Created by ISHIGO Yusuke on 2025/10/24.
//

import UIKit
import OSCKit

class InformaticsScene: BaseScene
{
	func checkMarks()
	{
		// RFIDデバイスに送信する
		let client = OSCUdpClient(host: "192.168.0.200", port: 55555)
		if let message = try? OSCMessage(with: "/light_on", arguments: [])
		{
			if let _ = try? client.send(message)
			{
			}
		}
	}
	
	func answerMarks(uuid1: String, uuid2: String, uuid3: String)
	{
		
	}

}
