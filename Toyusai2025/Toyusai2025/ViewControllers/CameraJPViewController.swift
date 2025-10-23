//
//  CameraJPViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/22.
//

import UIKit
import SceneKit
import ARKit
import AVFoundation

class CameraJPViewController: UIViewController, ARSCNViewDelegate
{

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet var sceneView: ARSCNView!
    var player: AVPlayer?
    
    @IBAction func BackBtnJ(_ sender: Any)
    {
        self.dismiss(animated: true , completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        sceneView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        // first see if there is a folder called "ARImages" Resource Group in our Assets Folder
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) {
            
            // if there is, set the images to track
            configuration.trackingImages = trackedImages
            // at any point in time, only 1 image will be tracked
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
        NotificationCenter.default.removeObserver(self)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        
        guard let url = Bundle.main.url(forResource: "JpAR", withExtension: "mov") else {return}
        
        let player = AVPlayer(url: url)
        self.player = player

        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main
        )
        {_ in
            print("画面遷移をする")
        }
        
        let videoNode = SKVideoNode(avPlayer: player)

        let videoScene = SKScene(size: CGSize(width: 591, height: 835))
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        videoNode.yScale = -1.0
        videoScene.addChild(videoNode)

        let plane = SCNPlane(
            width: imageAnchor.referenceImage.physicalSize.width,
            height: imageAnchor.referenceImage.physicalSize.height
        )
        plane.firstMaterial?.diffuse.contents = videoScene
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -Float.pi / 2

        DispatchQueue.main.async
        {
            self.backBtn.isHidden = true
            player.play()
        }

        node.addChildNode(planeNode)
    }
}
