//
//  HUDViewController.swift
//  Effex
//
//  Created by Steven Hurtado on 12/1/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit

protocol HUDViewControllerDelegate {
    func dDepth()
    func iDepth()
    func dExit()
    func iExit()
}

class HUDViewController : UIViewController
{
    //zoom controls
    var zoomOut : BlurButton?
    var zoomIn : BlurButton?
    
    var delegate : HUDViewControllerDelegate!
    
    override func viewDidLoad() {
        
        //set up for zoom components
        zoomOut = BlurButton(frame: CGRect(x: 8.0, y: self.view.frame.height/2-37.5, width: 75.0, height: 75.0), needIndicator: false)
        guard let zOut = zoomOut else{return}
        zOut.layer.cornerRadius = zOut.frame.width/2
        zOut.addBlurEffect(withStyle: .extraLight)
        zOut.updateMaskForView(text: "-")
        zOut.addTarget(self, action: #selector(zOutDepth), for: .touchDragEnter)
        zOut.addTarget(self, action: #selector(zOutExit), for: .touchDragOutside)
        
        zoomIn = BlurButton(frame: CGRect(x: self.view.frame.width-83.0, y: self.view.frame.height/2-37.5, width: 75.0, height: 75.0), needIndicator: false)
        guard let zIn = zoomIn else{return}
        zIn.layer.cornerRadius = zIn.frame.width/2
        zIn.addBlurEffect(withStyle: .extraLight)
        zIn.updateMaskForView(text: "+")
        zIn.addTarget(self, action: #selector(zInDepth), for: .touchDragEnter)
        zIn.addTarget(self, action: #selector(zInExit), for: .touchDragOutside)
        
        self.view.addSubview(zOut)
        self.view.addSubview(zIn)
    }
    
    @objc func zOutDepth() {
        print("+ in")
        delegate.dDepth()
    }
    @objc func zOutExit() {
        print("+ out")
        delegate.dExit()
    }
    
    @objc func zInDepth() {
        print("- in")
        delegate.iDepth()
    }
    @objc func zInExit() {
        print("- out")
        delegate.iExit()
    }
}
