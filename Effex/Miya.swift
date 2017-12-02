//
//  Miya.swift
//  Effex
//
//  Created by Steven Hurtado on 9/14/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import SceneKit
import UIKit

class Miya : NSObject {
    var body : SCNNode?
    var viewPort : SCNNode?
    var bodyLining : SCNNode?
    var jet : SCNNode?
    var nodes : [SCNNode?] = []
    var parent : SCNNode?
    var timer : Timer?
    
    init(body: SCNNode, viewPort: SCNNode, bodyLining: SCNNode, jet: SCNNode) {
        super.init()
        self.body = body
        self.viewPort = viewPort
        self.bodyLining = bodyLining
        self.jet = jet
        
        self.nodes = [self.body, self.viewPort, self.bodyLining, self.jet]
        self.makeParent(parent: self.body)
    }
    
    private func makeParent(parent: SCNNode?)
    {
        self.parent = parent
    }
    
    func miyaParticleSetUp()
    {
        if let jet = self.jet {
            let color = UIColor.myMiyaSunset
            guard let geometry = jet.geometry else {return}
            let trailEmitter = createTrail(color: color, geometry: geometry)
            jet.addParticleSystem(trailEmitter)
        }
    }
    
    func miyaHoverAnimation()
    {
        let moveUp = SCNAction.moveBy(x: 0, y: 0.5, z: 0, duration: 1)
        moveUp.timingMode = .easeInEaseOut;
        let moveDown = SCNAction.moveBy(x: 0, y: -0.5, z: 0, duration: 1)
        moveDown.timingMode = .easeInEaseOut;
        let moveSequence = SCNAction.sequence([moveUp,moveDown])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        
        if let node = self.parent
        {
            node.runAction(moveLoop)
        }
        
//        jet.runAction(moveLoop)
//        body.runAction(moveLoop)
//        bL.runAction(moveLoop)
    }
    
    func viewPortAnimation()
    {
        self.timer?.invalidate()
        if let vP = self.viewPort
        {
            var keyframe = 0
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { (Timer) in
                
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.06
                
                switch(keyframe) {
                case 0:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blink_animation0001")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "blink_animation0001")
                    break;
                case 1:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blink_animation0002")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "blink_animation0002")
                    break;
                case 2:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blink_animation0003")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "blink_animation0003")
                    break;
                case 3:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blink_animation0004")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "blink_animation0004")
                    break;
                case 4:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blink_animation0005")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "blink_animation0005")
                    break;
                case 5:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blink_animation0006")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "blink_animation0006")
                    break;
                case 6:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blink_animation0007")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "blink_animation0007")
                    break;
                case 7:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blink_animation0008")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "blink_animation0008")
                    break;
                case 8:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blink_animation0009")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "blink_animation0009")
                    break;
                default:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "blink_animation0001")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "blink_animation0001")
                    if(keyframe == 64) {
                        keyframe = 0
                    }
                    break;
                }
                keyframe += 1
                SCNTransaction.commit()
            }
        }
    }
    
    func loadingState()
    {
        self.timer?.invalidate()
        if let vP = self.viewPort
        {
            var keyframe = 0
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { (Timer) in
                
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.06
                
                switch(keyframe) {
                case 0:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0001")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0001")
                    break;
                case 1:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0003")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0003")
                    break;
                case 2:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0005")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0005")
                    break;
                case 3:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0007")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0007")
                    break;
                case 4:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0009")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0009")
                    break;
                case 5:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0011")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0011")
                    break;
                case 6:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0013")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0013")
                    break;
                case 7:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0015")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0015")
                    break;
                case 8:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0017")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0017")
                    break;
                case 9:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0019")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0019")
                    break;
                case 10:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0021")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0021")
                    break;
                default:
                    vP.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "loader0023")
                    vP.geometry?.firstMaterial?.emission.contents = UIImage(named: "loader0023")
                    if(keyframe == 24) {
                        keyframe = 0
                    }
                    break;
                }
                
                vP.geometry?.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(-1, -1, 1)
                vP.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat
                vP.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
                
                vP.geometry?.firstMaterial?.emission.contentsTransform = SCNMatrix4MakeScale(-1, -1, 1)
                vP.geometry?.firstMaterial?.emission.wrapT = SCNWrapMode.repeat
                vP.geometry?.firstMaterial?.emission.wrapS = SCNWrapMode.repeat
                
                keyframe += 1
                SCNTransaction.commit()
            }
        }
    }
    
    func createTrail(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem {
        guard let trail = SCNParticleSystem(named: "jetEmission.scnp", inDirectory: nil) else {return SCNParticleSystem()}
        trail.particleColor = color
        trail.emitterShape = geometry
        
        //trail general init
        trail.birthRate = 14.0
        trail.emittingDirection = SCNVector3Make(0.0, 0.0, 0.0)
        trail.spreadingAngle = 0.0
        trail.particleLifeSpan = 1.0
        trail.particleSize = 0.08
        trail.particleImage = UIImage(named: "bokeh.png")
        return trail
    }
}
