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
import ARKit
import NVActivityIndicatorView
import AudioToolbox

class ARSCNViewController : UIViewController
{
    var miya : Miya?
    var miyaPos : SCNVector3?
    var userPos : SCNVector3?
    var travAngle : Float?
    
     @IBOutlet var sceneView : ARSCNView!
    var boxes : [Box]?
    
    //hud
    var hud : HUDViewController?
    var hudFeaturesSet : Bool = false
    
    var globalZoomOutTimer : Timer?
    var globalZoomInTimer : Timer?
//    override func loadView() {
//        super.loadView()
//    }
//
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        guard let scene = SCNScene(named: "art.scnassets/miya copy 2.scn") else{return}
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.scene = scene

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 25)
        scene.rootNode.addChildNode(cameraNode)
        
        //set up for miya
        miyaSetUp(scene: scene)

        //scene attributes
        sceneView.autoenablesDefaultLighting = true

        //hud set up
        let holdGesture = UILongPressGestureRecognizer(target: self, action: #selector(longStarted))
        holdGesture.minimumPressDuration = 1.0
        holdGesture.cancelsTouchesInView = false
//        holdGesture.numberOfTouchesRequired

        self.view.gestureRecognizers?.append(holdGesture)
        hudSetUp()
        
        //collection view set up
//        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 250))
    }
    
    func hudSetUp() {
        self.hud = HUDViewController()
        if let hud = self.hud {
            hud.view.backgroundColor = UIColor.clear
            hud.delegate = self
            
            self.view.addSubview(hud.view)
            
            hud.zoomOut?.alpha = 0.0
            hud.zoomIn?.alpha = 0.0
            
            self.userPos = self.sceneView.pointOfView?.position
            self.travAngle = 0.0
            print("User: \(self.userPos)")
        }
    }
    
    @objc func longStarted() {
        if(!hudFeaturesSet) {
            hudFeaturesSet = true
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            
            if let hud = self.hud {
                hud.zoomOut?.alpha = 0.0
                hud.zoomIn?.alpha = 0.0
                UIView.animate(withDuration: 1.24) {
                    hud.zoomOut?.alpha = 0.5
                    hud.zoomIn?.alpha = 0.5
                }
                
                hud.startListening()
            }
        }
    }
    
    func miyaSetUp(scene: SCNScene) {
        guard let jet = scene.rootNode.childNode(withName: "Jet", recursively: true) else{return}
        guard let viewPort = scene.rootNode.childNode(withName: "ViewPort", recursively: true) else{return}
        guard let bodyLining = scene.rootNode.childNode(withName: "BodyLining", recursively: true) else{return}
        guard let body = scene.rootNode.childNode(withName: "Body", recursively: true) else{return}
        
        miya = Miya(body: body, viewPort: viewPort, bodyLining: bodyLining, jet: jet)

        if let parent = miya?.parent
        {
            let it = SCNLookAtConstraint(target: sceneView.pointOfView)
            it.isGimbalLockEnabled = true
            parent.constraints = [it]
            parent.pivot = SCNMatrix4MakeRotation(Float.pi, 0, 1, 1)
            self.miyaPos = parent.position
            print("Miya: \(self.miyaPos)")
        }
        
        miya?.miyaHoverAnimation()
        miya?.viewPortAnimation()
        
        miya?.miyaParticleSetUp()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start the `ARSession`.
        resetTracking()
    }
    
    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
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
            
//            let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 250, height: 250))
//            let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewLayout())
//            collectionView.dataSource = self
//            collectionView.delegate = self
//            self.sceneView?.addSubview(collectionView)
        })
    }
    
    //MARK: - TOUCH
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cleanUpTimer()
        print("END")
        if hudFeaturesSet, let hud = self.hud {
            UIView.animate(withDuration: 1.24) {
                hud.zoomOut?.alpha = 0.0
                hud.zoomIn?.alpha = 0.0
            }
        }
        
        self.hud?.touchViewer?.alpha = 1.0
        UIView.animate(withDuration: 0.48, animations: {
            self.hud?.touchViewer?.alpha = 1.0
        }) { (bool) in
            self.hud?.touchViewer?.stopAnimating()
        }
        
        hudFeaturesSet = false
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        let hitList = sceneView.hitTest(touch.location(in: sceneView), options: nil)
        if hitList.count > 0 {
            if let hitObject = hitList.first {
                let node = hitObject.node
                if let children = self.miya?.nodes
                {
                    for child in children
                    {
                        if child == node {
                            checkForBox()
                            return
                        }
                    }
                }
            }
        }
        else {
            let result = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
            guard let hitResult = result.last else{return}
            let hitTransform = SCNMatrix4(hitResult.worldTransform)
            let position = SCNVector3(x: hitTransform.m41, y: hitTransform.m42, z: hitTransform.m43)
            print("Pos: \(position)")
            self.userPos = self.sceneView.pointOfView?.position
            if let m = self.miyaPos, let pov = self.userPos {
                let a = SCNVector3.calcDistXZ(a: m, b: pov)
                print("A: \(a)")
                let b = SCNVector3.calcDistXZ(a: position, b: m)
                print("B: \(b)")
                let c = SCNVector3.calcDistXZ(a: position, b: pov)
                print("C: \(c)")
                travAngle = SCNVector3.calcTheta(a: a, b: b, c: c)
                print("THETA: \(travAngle)")
            }

            self.moveToTouch(position: position)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        
        if hudFeaturesSet, let hud = self.hud {
            let location = touch.location(in: hud.view)
            print(location)
            print(hud.zoomIn?.frame)
            if let touchView = hud.touchViewer {
                //update visible position of touch
                touchView.frame.origin = CGPoint(x: location.x-touchView.frame.width/2, y: location.y-touchView.frame.height/2)
                
                //detect collision
                hud.verifyCollision()
            }
        }
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
    
    func moveToTouch(position: SCNVector3)
    {
        if let parent = miya?.parent {
            let motion = SCNAction.move(to: position, duration: 0.84)
            motion.timingMode = .easeInEaseOut
            let moveSequence = SCNAction.sequence([motion])
            let moveLoop = SCNAction.repeat(moveSequence, count: 1)
            parent.runAction(moveLoop)
            self.miyaPos = position
        }
    }

    func getUserDirection() -> SCNVector3 {
        if let frame = self.sceneView.session.currentFrame {
            let mat = SCNMatrix4(frame.camera.transform)
            return SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        }
        return SCNVector3(0, 0, -1)
    }
    
    @objc func decreaseDepth() {
        if let parent = miya?.parent {
            if let theta = self.travAngle {
                print("Theta: \(theta)")
                let posX = parent.position.x - 0.01*sin(theta)
                let posZ = parent.position.z - 0.01*cos(theta)
                parent.position.x = posX
                parent.position.z = posZ

            }
           //            parent.physicsBody?.applyForce(direction, asImpulse: true)
        }
    }
    
    @objc func increaseDepth() {
        if let parent = miya?.parent {
            let posZ = parent.position.z + 0.01
            parent.position.z = posZ
//            parent.rotation.z = parent.rotation.z + 0.1
            
            print(parent.orientation)
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView?.session.pause()
    }
    
    func cleanUpTimer() {
        self.globalZoomOutTimer?.invalidate()
        self.globalZoomOutTimer = Timer()
        
        self.globalZoomInTimer?.invalidate()
        self.globalZoomInTimer = Timer()
    }
}

extension ARSCNViewController: ARSCNViewDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        return node
    }
}

extension ARSCNViewController: HUDViewControllerDelegate {
    func dDepth() {
        print("fire d")
        cleanUpTimer()
        
        self.globalZoomOutTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(decreaseDepth), userInfo: nil, repeats: true)
        self.globalZoomOutTimer?.fire()
    }
    
    func iDepth() {
        print("fire i")
        cleanUpTimer()
        
        self.globalZoomInTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(increaseDepth), userInfo: nil, repeats: true)
        self.globalZoomInTimer?.fire()
    }
    
    func clear() {
        cleanUpTimer()
    }
}

//extension ARSCNViewController: UICollectionViewDelegate, UICollectionViewDataSource
//{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.boxes?.count ?? 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.cellForItem(at: indexPath) else {return UICollectionViewCell()}
//
//        if let box = self.boxes?[indexPath.row] {
//            let action = box.actions?[0]
//
//            let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 100))
//
//            if let actionText = action?.action
//            {
//                label.text = actionText
//            }
//
//            cell.addSubview(label)
//        }
//
//        return cell
//    }
//
//
//}

