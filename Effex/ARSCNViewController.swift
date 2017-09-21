//
//  ARSCNViewController.swift
//  Miya
//
//  Created by Steven Hurtado on 9/20/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import SceneKit
import UIKit

class ARSCNViewController : UIViewController
{
    var miya : Miya?
    var sceneView : SCNView?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        guard let scene = SCNScene(named: "art.scnassets/miya.scn") else{return}
        let scnView = self.view as? SCNView
        self.sceneView = scnView
        guard let sceneView = self.sceneView else{return}
    
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        
        omniLightNode.light?.type = .omni
        omniLightNode.light?.color = UIColor(white: 0.75, alpha: 1.0)
        omniLightNode.position = SCNVector3Make(0, 50, 50)
        scene.rootNode.addChildNode(omniLightNode)
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 25)
        scene.rootNode.addChildNode(cameraNode)

        //set up for miya
        guard let jet = scene.rootNode.childNode(withName: "Jet", recursively: true) else{return}
        guard let viewPort = scene.rootNode.childNode(withName: "ViewPort", recursively: true) else{return}
        guard let bodyLining = scene.rootNode.childNode(withName: "BodyLining", recursively: true) else{return}
        guard let body = scene.rootNode.childNode(withName: "Body", recursively: true) else{return}
        
        miya = Miya(body: body, viewPort: viewPort, bodyLining: bodyLining, jet: jet)
    
        miya?.miyaHoverAnimation()
        miya?.viewPortAnimation()
        
        miya?.miyaParticleSetUp()
        
        sceneView.autoenablesDefaultLighting = true
        
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.backgroundColor = UIColor.groupTableViewCell
        
        let recog = UITapGestureRecognizer(target: self, action: #selector(moveToTouch(_:)))
        recog.numberOfTapsRequired = 1
        recog.numberOfTouchesRequired = 1
        sceneView.gestureRecognizers?.append(recog)
    }
    
    func CGPointToSCNVector3(view: SCNView, depth: Float, point: CGPoint) -> SCNVector3 {
        let projectedOrigin = view.projectPoint(SCNVector3Make(0, 0, depth))
        let locationWithz   = SCNVector3Make(Float(point.x), Float(point.y), projectedOrigin.z)
        return view.unprojectPoint(locationWithz)
    }
    
    func getDirection(for point: CGPoint, in view: SCNView) -> SCNVector3 {
        let farPoint  = view.unprojectPoint(SCNVector3Make(Float(point.x), Float(point.y), 1))
        let nearPoint = view.unprojectPoint(SCNVector3Make(Float(point.x), Float(point.y), 0))
        
        return SCNVector3Make(farPoint.x - nearPoint.x, farPoint.y - nearPoint.y, farPoint.z - nearPoint.z)
    }
    
    @objc func moveToTouch(_ recognizer: UITapGestureRecognizer)
    {
        guard let sceneView = self.sceneView else{return}

        let location = recognizer.location(in: sceneView)
        
        let hitResults = sceneView.hitTest(location, options: nil)
        if hitResults.count > 0 {
            let result = hitResults[0] as SCNHitTestResult
            let node = result.node
            
            if let children = self.miya?.nodes
            {
                for child in children
                {
                    if child == node {
                        miya?.loadingState()
                        break
                    }
                }
            }
        }
        else {
            if let parent = miya?.parent {
                print(location)
                let position = CGPointToSCNVector3(view: sceneView, depth: parent.position.z, point: location)
                print(position)
                let motion = SCNAction.move(to: position, duration: 0.84)
                motion.timingMode = .easeInEaseOut
                let moveSequence = SCNAction.sequence([motion])
                let moveLoop = SCNAction.repeat(moveSequence, count: 1)
                parent.runAction(moveLoop)
            }
        }
    }
}
