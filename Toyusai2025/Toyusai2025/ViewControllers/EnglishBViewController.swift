//
//  EnglishBViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/21.
//

import UIKit

class EnglishBViewController: UIViewController
{

    @IBOutlet weak var EngBtnB: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        EngBtnB.layer.borderWidth = 2            // 線の太さ
        EngBtnB.layer.borderColor = UIColor.black.cgColor  // 線の色
        EngBtnB.layer.cornerRadius = 30
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
