//
//  JapaneseViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/22.
//

import UIKit

class JapaneseViewController: UIViewController
{

    @IBOutlet weak var JpBtn: UIButton!
    @IBOutlet weak var BugBtn: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        JpBtn.layer.borderWidth = 2            // 線の太さ
        JpBtn.layer.borderColor = UIColor.black.cgColor  // 線の色
        JpBtn.layer.cornerRadius = 30
        BugBtn.layer.borderWidth = 2            // 線の太さ
        BugBtn.layer.borderColor = UIColor.white.cgColor  // 線の色
        BugBtn.layer.cornerRadius = 30
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
