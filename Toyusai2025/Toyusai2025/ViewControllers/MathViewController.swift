//
//  MathViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/21.
//

import UIKit

class MathViewController: BaseViewController
{
    @IBOutlet weak var answerBtn: UIButton!
    @IBOutlet weak var TextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
		
		// 線の太さ
        answerBtn.layer.borderWidth = 2
		// 線の色
        answerBtn.layer.borderColor = UIColor.black.cgColor
        answerBtn.layer.cornerRadius = 30
    }
    

}
