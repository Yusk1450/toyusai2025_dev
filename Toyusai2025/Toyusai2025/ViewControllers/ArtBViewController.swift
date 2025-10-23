//
//  ArtBViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/21.
//

import UIKit

class ArtBViewController: UIViewController
{

    @IBOutlet weak var ArtBtnB: UIButton!
    @IBOutlet weak var ACameraBtn: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ArtBtnB.layer.borderWidth = 2            // 線の太さ
        ArtBtnB.layer.borderColor = UIColor.black.cgColor  // 線の色
        ArtBtnB.layer.cornerRadius = 30
        
        ACameraBtn.layer.borderWidth = 2            // 線の太さ
        ACameraBtn.layer.borderColor = UIColor.white.cgColor  // 線の色
        ACameraBtn.layer.cornerRadius = 30
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
