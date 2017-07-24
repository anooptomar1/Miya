//
//  Util.swift
//  Effex
//
//  Created by Steven Hurtado on 7/19/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func setUpParallax(rate: Double) {
        //three rates max
        
        if !(rate > 0 && rate < 4) {return}
        
        let min = CGFloat(-30.0*rate)
        let max = CGFloat(30.0*rate)
        
        let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = min
        xMotion.maximumRelativeValue = max
        
        let yMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = CGFloat(-30.0)
        yMotion.maximumRelativeValue = CGFloat(30.0)
        
        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion,yMotion]
        self.addMotionEffect(motionEffectGroup)
    }
    
    func setUpAnimation(quiver: Double, maxAlpha: CGFloat, minAlpha: CGFloat) {
        
        _ = Timer.scheduledTimer(withTimeInterval: quiver, repeats: true, block: { (timer: Timer) in
            self.alpha = maxAlpha
            UIView.animate(withDuration: quiver/2.0, animations: {
                self.alpha = minAlpha
            }) { (true: Bool) in
                UIView.animate(withDuration: quiver/2.0, animations: {
                    self.alpha = maxAlpha
                })
            }
        })
    }
}

extension UIColor
{
    //langua colors
    static var myMugiwaraYellow: UIColor
    {
        //E1CE7A
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    static var myOuterSpaceBlack: UIColor
    {
        //424B54
        return UIColor(red: 66.0/255.0, green: 75.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    static var myLightBambooGreen: UIColor
    {
        //6BCF63
        return UIColor(red: 107.0/255.0, green: 207.0/255.0, blue: 99.0/255.0, alpha: 1)
    }
    
    static var myDarkBambooGreen: UIColor
    {
        //4C9347
        return UIColor(red: 76.0/255.0, green: 147.0/255.0, blue: 71.0/255.0, alpha: 1)
    }
    
    static var myIsabellineWhite: UIColor
    {
        //F6E8EA
        return UIColor(red: 246.0/255.0, green: 232.0/255.0, blue: 234.0/255.0, alpha: 1)
    }
    
    static var myCarminePink: UIColor
    {
        //EF626C
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    //sg colors
    static var myCreamOrange: UIColor
    {
        //FA7B54
        return UIColor(red: 250.0/255.0, green: 123.0/255.0, blue: 84.0/255.0, alpha: 1)
    }
    
    static var myDullBlue: UIColor
    {
        //5B7FA4
        return UIColor(red: 91.0/255.0, green: 127.0/255.0, blue: 164.0/255.0, alpha: 1)
    }
    
    static var groupTableViewCell: UIColor
    {
        //EBEBF1
        return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 241.0/255.0, alpha: 1)
    }
    
    
    //other colors
    static var myOffWhite: UIColor
    {
        //FAFAFA
        return UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1)
    }
    
    static var mySalmonRed: UIColor
    {
        //F55D3E
        return UIColor(red: 245.0/255.0, green: 93.0/255.0, blue: 62.0/255.0, alpha: 1)
    }
    
    static var myRoseMadder: UIColor
    {
        //D72638
        return UIColor(red: 215.0/255.0, green: 38.0/255.0, blue: 56.0/255.0, alpha: 1)
    }
    
    static var myOnyxGray: UIColor
    {
        //878E88
        return UIColor(red: 135.0/255.0, green: 142.0/255.0, blue: 136.0/255.0, alpha: 1)
    }
    
    static var myTimberWolf: UIColor
    {
        //DAD6D6
        return UIColor(red: 218.0/255.0, green: 214.0/255.0, blue: 214.0/255.0, alpha: 1)
    }
    
    
    static var myMatteGold: UIColor
    {
        //F7CB15
        return UIColor(red: 247.0/255.0, green: 203.0/255.0, blue: 21.0/255.0, alpha: 1)
    }
    
    static var twitterBlue: UIColor
    {
        //00aced
        return UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1)
    }
}
