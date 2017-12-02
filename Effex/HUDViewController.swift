//
//  HUDViewController.swift
//  Effex
//
//  Created by Steven Hurtado on 12/1/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

class HUDViewController : UIViewController
{
    //zoom controls
    var zoomOut : BlurButton?
    var zoomIn : BlurButton?
    
    override func viewDidLoad() {
        zoomOut = BlurButton(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0), needIndicator: false)
        guard let zOut = zoomOut else{return}
        zOut.layer.cornerRadius = zOut.frame.width/2
        zOut.addBlurEffect(withStyle: .extraLight)
        zOut.updateMaskForView(text: "-")
        
        
        zoomIn = BlurButton(frame: CGRect(x: self.view.frame.width-100.0, y: 0.0, width: 100.0, height: 100.0), needIndicator: false)
        guard let zIn = zoomIn else{return}
        zIn.layer.cornerRadius = zIn.frame.width/2
        zIn.addBlurEffect(withStyle: .extraLight)
        zIn.updateMaskForView(text: "+")
        
        self.view.addSubview(zOut)
        self.view.addSubview(zIn)
    }
}
