//
//  HUDViewController.swift
//  Effex
//
//  Created by Steven Hurtado on 12/1/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

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
    
    //touch controls
    var touchViewer : NVActivityIndicatorView?
    
    var delegate : HUDViewControllerDelegate!
    
    override func viewDidLoad() {
        
        //set up for zoom components
        zoomOut = BlurButton(frame: CGRect(x: 8.0, y: self.view.frame.height/2-37.5, width: 75.0, height: 75.0), needIndicator: false)
        guard let zOut = zoomOut else{return}
        zOut.layer.cornerRadius = zOut.frame.width/2
        zOut.addBlurEffect(withStyle: .extraLight)
        zOut.updateMaskForView(text: "-")
        zOut.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 24)
        zOut.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(zOutDepth)))//addTarget(self, action: #selector(zOutDepth), for: .touchDragEnter)
        zOut.addTarget(self, action: #selector(zOutExit), for: .touchDragOutside)
        
        zoomIn = BlurButton(frame: CGRect(x: self.view.frame.width-83.0, y: self.view.frame.height/2-37.5, width: 75.0, height: 75.0), needIndicator: false)
        guard let zIn = zoomIn else{return}
        zIn.layer.cornerRadius = zIn.frame.width/2
        zIn.addBlurEffect(withStyle: .extraLight)
        zIn.updateMaskForView(text: "+")
        zIn.titleLabel?.font = UIFont(name: "Avenir Next Regular", size: 24)
        zIn.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(zInDepth)))//addTarget(self, action: #selector(zInDepth), for: .touchDragEnter)
        zIn.addTarget(self, action: #selector(zInExit), for: .touchDragOutside)
        
        self.view.addSubview(zOut)
        self.view.addSubview(zIn)
        
        //touch indicator
        touchViewer = NVActivityIndicatorView(frame: CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0), type: .ballScaleRippleMultiple, color: UIColor.myMiyaSunset, padding: 8.0)
        if let touchViewer = self.touchViewer {
            touchViewer.alpha = 0.0
            self.view.addSubview(touchViewer)
        }
    }
    
    func startListening() {
        print("started listening")
        touchViewer?.alpha = 0.0
        touchViewer?.startAnimating()
        UIView.animate(withDuration: 0.48) {
            self.touchViewer?.alpha = 1.0
        }
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
