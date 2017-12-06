//
// Equate.swift
//  Effex
//
//  Created by Steven Hurtado on 12/6/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import SceneKit

extension SCNVector3 {
    static func calcDistXZ(a: SCNVector3, b: SCNVector3) -> Float
    {return sqrtf(pow((a.x-b.x), 2) + pow((a.z-b.z), 2))}
    
    static func calcTheta(a: Float, b: Float, c: Float) -> Float
    {
        return acos((pow(c, 2) + pow(a, 2) - pow(b, 2)) / (2*a*c))
    }
}
