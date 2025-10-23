//
//  InformationBViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/21.
//

import UIKit

class InformationBViewController: UIViewController {

    @IBOutlet weak var InfoBtnB: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        InfoBtnB.layer.borderWidth = 2            // 線の太さ
        InfoBtnB.layer.borderColor = UIColor.black.cgColor  // 線の色
        InfoBtnB.layer.cornerRadius = 30
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
