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
    
    init(body: SCNNode, viewPort: SCNNode, bodyLining: SCNNode, jet: SCNNode) {
        self.body = body
        self.viewPort = viewPort
        self.bodyLining = bodyLining
        self.jet = jet
        
        self.nodes = [self.body, self.viewPort, self.bodyLining, self.jet]
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
//        guard let vP = self.viewPort else {return}
//        guard let jet = self.jet else {return}
//        guard let body = self.body else {return}
//        guard let bL = self.bodyLining else {return}
//
        let moveUp = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1)
        moveUp.timingMode = .easeInEaseOut;
        let moveDown = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1)
        moveDown.timingMode = .easeInEaseOut;
        let moveSequence = SCNAction.sequence([moveUp,moveDown])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        
        for node in nodes {
            if let node = node
            {
                node.runAction(moveLoop)
            }
        }
//        jet.runAction(moveLoop)
//        body.runAction(moveLoop)
//        bL.runAction(moveLoop)
    }
    
    func viewPortAnimation()
    {
        if let vP = self.viewPort
        {
            var keyframe = 0
            _ = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { (Timer) in
                
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
    
    func createTrail(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem {
        guard let trail = SCNParticleSystem(named: "jetEmission.scnp", inDirectory: nil) else {return SCNParticleSystem()}
        trail.particleColor = color
        trail.emitterShape = geometry
        
        //trail general init
        trail.birthRate = 25.0
        trail.emittingDirection = SCNVector3Make(0.0, 0.0, 0.0)
        trail.spreadingAngle = 0.0
        trail.particleLifeSpan = 1.0
        trail.particleSize = 0.2
        trail.particleImage = UIImage(named: "bokeh.png")
        return trail
    }
}
