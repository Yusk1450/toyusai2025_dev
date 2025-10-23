//
//  CameraJPViewController.swift
//  Toyusai2025
//
//  Created by 橋本晄汰 on 2025/10/22.
//

import UIKit
import SceneKit
import ARKit

class CameraJPViewController: UIViewController, ARSCNViewDelegate
{

    @IBOutlet var sceneView: ARSCNView!
    
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
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        // if the anchor is not of type ARImageAnchor (which means image is not detected), just return
        guard let imageAnchor = anchor as? ARImageAnchor else {return}
        //find our video file
        let videoNode = SKVideoNode(fileNamed: "JpAR.mp4")
        videoNode.play()
        // set the size (just a rough one will do)
        let videoScene = SKScene(size: CGSize(width: 1920, height: 1080))
        // center our video to the size of our video scene
        videoNode.position = CGPoint(x: videoScene.size.width / 2, y: videoScene.size.height / 2)
        // invert our video so it does not look upside down
        videoNode.yScale = -1.0
        // add the video to our scene
        videoScene.addChild(videoNode)
        // create a plan that has the same real world height and width as our detected image
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        // set the first materials content to be our video scene
        plane.firstMaterial?.diffuse.contents = videoScene
        // create a node out of the plane
        let planeNode = SCNNode(geometry: plane)
        // since the created node will be vertical, rotate it along the x axis to have it be horizontal or parallel to our detected image
        planeNode.eulerAngles.x = -Float.pi / 2
        // finally add the plane node (which contains the video node) to the added node
        node.addChildNode(planeNode)
    }

}
