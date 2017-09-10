//
//  BlurButton.swift
//  Effex
//
//  Created by Steven Hurtado on 7/22/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BlurButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var indicator : NVActivityIndicatorView!
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = self.frame.width/2
        self.clipsToBounds = true
        
        indicator = NVActivityIndicatorView(frame: CGRect(x: 8, y: 8, width: self.frame.width-16, height: self.frame.height-16), type: .orbit, color: UIColor.myMiyaSunset, padding: 0)
        self.addSubview(indicator)
    }
    
    func updateMaskForView(text: String, invert : Bool = true) {
        self.titleLabel?.text = text
        self.clearTextButton(button: self, title: text, color: UIColor.clear)
    }
    
    func load() {
        self.layer.mask?.removeFromSuperlayer()

        self.bringSubview(toFront: indicator)
        indicator.startAnimating()
    }
    
    func clearTextButton(button: UIButton, title: String, color: UIColor) {
        button.backgroundColor = color
        button.titleLabel?.backgroundColor = UIColor.clear
        button.setTitleColor(UIColor.clear, for: .normal)
        button.setTitle(title, for: [])
        
        guard let titleLabel = button.titleLabel else {return}
        let buttonSize: CGSize = button.bounds.size
        let font: UIFont = titleLabel.font
        let attribs: [NSAttributedStringKey : AnyObject] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): titleLabel.font]
        let textSize: CGSize = title.size(withAttributes: attribs)
        UIGraphicsBeginImageContextWithOptions(buttonSize, false, UIScreen.main.scale)
        guard let ctx: CGContext = UIGraphicsGetCurrentContext() else{return}
        ctx.setFillColor(UIColor.white.cgColor)
        let center: CGPoint = CGPoint(x: buttonSize.width / 2 - textSize.width / 2, y: buttonSize.height / 2 - textSize.height / 2)
        let path: UIBezierPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: buttonSize.width, height: buttonSize.height))
        ctx.addPath(path.cgPath)
        ctx.fillPath()
        ctx.setBlendMode(.destinationOut)
        title.draw(at: center, withAttributes: [NSAttributedStringKey.font: font])
        guard let viewImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else {return}
        UIGraphicsEndImageContext()
        let maskLayer: CALayer = CALayer()
        maskLayer.contents = ((viewImage.cgImage) as AnyObject)
        maskLayer.frame = button.bounds
        button.layer.mask = maskLayer
    }
    
    func maskBlur() {
        self.mask = self.titleLabel
    }
    
    func addBlurEffect(withStyle style: UIBlurEffectStyle)
    {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: style))
        blur.frame = self.bounds
        blur.isUserInteractionEnabled = false
        self.insertSubview(blur, at: 0)
        if let imageView = self.imageView {
            self.bringSubview(toFront: imageView)
        }
    }
}
