//
//  ArtAViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/21.
//

import UIKit

class ArtAViewController: UIViewController
{
    @IBOutlet weak var ArtBtnA: UIButton!
    @IBOutlet weak var ACameraBtnA: UIButton!

	override func viewDidLoad()
    {
        super.viewDidLoad()

        ArtBtnA.layer.borderWidth = 2
        ArtBtnA.layer.borderColor = UIColor.black.cgColor
        ArtBtnA.layer.cornerRadius = 30
        
        ACameraBtnA.layer.borderWidth = 2
        ACameraBtnA.layer.borderColor = UIColor.white.cgColor
        ACameraBtnA.layer.cornerRadius = 30
    }

}
