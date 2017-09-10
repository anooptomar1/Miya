//
//  GTBackground.swift
//  Effex
//
//  Created by Steven Hurtado on 7/22/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class GTBackground : UIView {
    var gtView : UIView?
    
    var red1: CGFloat = CGFloat(arc4random_uniform(256))
    var green1: CGFloat = CGFloat(arc4random_uniform(256))
    var blue1: CGFloat = CGFloat(arc4random_uniform(256))
    var redBool: Bool = true
    var greenBool: Bool = true
    var blueBool: Bool = true
    var speed = Double()
    
    var timer = Timer()
    
    //random intial color
    init(frame: CGRect, speed: Double) {
        super.init(frame: frame)
        self.speed = speed
        
        initializeGT()
    }
    
    //given intial color
    init(frame: CGRect, initialRed: CGFloat, initialGreen: CGFloat, initialBlue: CGFloat, speed: Double) {
        super.init(frame: frame)
        self.red1 = initialRed//CGFloat(66.0)
        self.green1 = initialGreen//CGFloat(75.0)
        self.blue1 = initialBlue//CGFloat(84.0)
        self.speed = speed
        
        initializeGT()
    }
    
    func initializeGT() {
        gtView = UIView(frame: self.frame)
        guard let view = gtView else {return}
        
        self.addSubview(view)
        
        self.fire()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func fire() {
        timer = Timer.scheduledTimer(timeInterval: self.speed, target: self, selector: #selector(movement), userInfo: nil, repeats: true)
    }
    
    @objc func movement()
    {
        //gradient animation
        backgroundAnimation(r1: red1, g1: green1, b1: blue1)
    }
    
    func backgroundAnimation(r1: CGFloat, g1: CGFloat, b1: CGFloat)
    {
        let red1Temp = r1
        let green1Temp = g1
        let blue1Temp = b1
        
        var red2: CGFloat// = 0.0
        var green2: CGFloat// = 0.0
        var blue2: CGFloat// = 0.0
        
        if(redBool) { red2 = r1 + 0.01*CGFloat(arc4random_uniform(8)) }
        else { red2 = r1 - 0.01*CGFloat(arc4random_uniform(8)) }
        
        if(greenBool) { green2 = g1 + 0.01*CGFloat(arc4random_uniform(8)) }
        else { green2 = g1 - 0.01*CGFloat(arc4random_uniform(8)) }
        
        if(blueBool) { blue2 = b1 + 0.01*CGFloat(arc4random_uniform(8)) }
        else { blue2 = b1 - 0.01*CGFloat(arc4random_uniform(8))}
        
        
        if(red2 >= 255) { red2 = 255; redBool = false}
        else if(red2 <= 0) { red2 = 0; redBool = true}
        
        if(green2 >= 255) { green2 = 255; greenBool = false}
        else if(green2 <= 0) { green2 = 0; greenBool = true}
        
        if(blue2 >= 255) { blue2 = 255; blueBool = false}
        else if(blue2 <= 0) {blue2 = 0; blueBool = true}
        
        let topColor = UIColor(red: (red1Temp/255.0), green: (green1Temp/255.0), blue: (blue1Temp/255.0), alpha: 0.7)
        
        let bottomColor = UIColor(red: (red2/255.0), green: (green2/255.0), blue: (blue2/255.0), alpha: 0.7)
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        gradientLayer.frame = self.bounds
        
        guard let view = gtView else {return}
        view.layer.sublayers?.removeAll()
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        self.sendSubview(toBack: view)
        
        self.red1 = red2; self.green1 = green2; self.blue1 = blue2
    }
}

