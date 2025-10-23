//
//  CameraArtViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/22.
//

import UIKit
import CoreImage

class CameraArtViewController: UIViewController, CamCaptureDelegate
{
    
    let camera = CamCapture()
    private let preview = UIImageView()
    
    @IBOutlet weak var ABackBtn: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    
    @IBAction func ArtBackBtn(_ sender: Any)
    {
        self.dismiss(animated: true , completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        preview.frame = view.bounds
        preview.contentMode = .scaleAspectFill
        view.addSubview(preview)
        
        camera.delegate = self
        camera.captureMode = .grayView
        
        camera.redThreshold = 0.3 // 赤が他のgbよりどれくらい強いか
        camera.minRed = 0.1 // どれだけ明るい赤か
        
        camera.greenThreshold = 0.3 // 緑が他のrbよりどれくらい強いか
        camera.minGreen = 0.1 // どれだけ明るい緑か
        
        camera.blueThreshold = 0.3 // 青が他のrgよりどれくらい強いか
        camera.minBlue = 0.1 // どれだけ明るい青か
        
        view.bringSubviewToFront(redButton)
        view.bringSubviewToFront(greenButton)
        view.bringSubviewToFront(blueButton)
        view.bringSubviewToFront(ABackBtn)
        setButtonImage(color: "none")
        
    }
    
    @IBAction func redCaptureMode(_ sender: UIButton) {
        camera.captureMode = .redView
        setButtonImage(color: "red")
    }
    
    @IBAction func greenCaptureMode(_ sender: UIButton) {
        camera.captureMode = .greenView
        setButtonImage(color: "green")
    }
    
    @IBAction func blueCaptureMode(_ sender: UIButton) {
        camera.captureMode = .blueView
        setButtonImage(color: "blue")
    }
    
    func camCaptureDidCapture(image: UIImage) {}
    func camCaptureDidRecord(url: URL) {}
    
    func camCaptureDidOutputFrame(image: UIImage)
    {
        DispatchQueue.main.async
        {
            self.preview.image = image
        }
    }
    
    func setButtonImage (color:String)
    {
        self.redButton.setImage(UIImage(named: "button_r_none"), for: .normal)
        self.greenButton.setImage(UIImage(named: "button_g_none"), for: .normal)
        self.blueButton.setImage(UIImage(named: "button_b_none"), for: .normal)
        
        if (color == "red")
        {
            self.redButton.setImage(UIImage(named: "button_r"), for: .normal)
        }
        else if (color == "green")
        {
            self.greenButton.setImage(UIImage(named: "button_g"), for: .normal)
        }
        else if (color == "blue")
        {
            self.blueButton.setImage(UIImage(named: "button_b"), for: .normal)
        }
        
    }
}
    



