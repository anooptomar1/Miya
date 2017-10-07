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
    
    var boxes : [Box]?
    
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
        
        //collection view set up
//        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 250))
    }
    
    func checkForBox()
    {
        //enter loading state
        self.miya?.loadingState()
        self.view.isUserInteractionEnabled = false
        
        //make request to server to compare locations of Box-s versus Miya's location
            //pass Miya's calculated 3D position in real space
        
            //if there are any number of [Box]
                //indicate actions and their states
            //error
                //no boxes || no connection || other
                //notify user with error bubble
        
            //end loading state
        
        // sudo data for boxes
        var dict : NSDictionary = ["result" : [ ["id" : "456"],
                                        ["actions" :
                                            [["action" : "Lamp 1"],
                                             ["triggered" : 0]]],
                                        ["position" :
                                            [["lat" : 1.1],
                                             ["long" : 2.2],
                                             ["z" : 5.0]]]]]
        let box : Box = Box(dict: dict)
        
        dict = ["result" : [ ["id" : "457"],
                    ["actions" :
                        [["action" : "Radio 2"],
                        ["triggered" : 0]]],
                    ["position" :
                        [["lat" : 1.1],
                        ["long" : 2.2],
                        ["z" : 5.0]]]]]

        let box2 : Box = Box(dict: dict)
        let boxes : [Box] = [box, box2]
        
        _ = Timer.scheduledTimer(withTimeInterval: 2.4, repeats: false, block: { (timer) in
            self.miya?.viewPortAnimation()
            self.view.isUserInteractionEnabled = true
            self.boxes = boxes
            
            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 250))
            let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewLayout())
            collectionView.dataSource = self
            collectionView.delegate = self
            self.view.addSubview(collectionView)
        })
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
                        checkForBox()
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

extension ARSCNViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.boxes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.cellForItem(at: indexPath) else {return UICollectionViewCell()}
        
        if let box = self.boxes?[indexPath.row] {
            let action = box.actions?[0]
            
            let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 100))
            
            if let actionText = action?.action
            {
                label.text = actionText
            }
            
            cell.addSubview(label)
        }
        
        return cell
    }
    
    
}
