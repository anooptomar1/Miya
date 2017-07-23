//
//  ViewController.swift
//  Effex
//
//  Created by Steven Hurtado on 7/17/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import CoreMotion
import AudioToolbox
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var gtLabel: UILabel!
    
    @IBOutlet weak var dragBtn: BlurButton!
    var initialCenter : CGPoint?
    
    @IBOutlet weak var entryBtn: BlurButton!
    
    @IBOutlet weak var switchBtnContainer: UIView!
    
    //arrows
    @IBOutlet weak var arrowOne: UIImageView!
    @IBOutlet weak var arrowTwo: UIImageView!
    @IBOutlet weak var arrowThree: UIImageView!
    
    var kWebAppWidth = CGFloat()
    var kWebAppHeight = CGFloat()
    
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //UIColor(red: 66.0/255.0, green: 75.0/255.0, blue: 84.0/255.0, alpha: 1)
        
        //let gtView = GTBackground(frame: self.view.frame, initialRed: 66.0, initialGreen: 75.0, initialBlue: 84.0, speed: 0.001)
        //self.view.addSubview(gtView)
//        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width*2, height: self.view.frame.height*2)
//        self.webView.scrollView.contentSize = CGSize(width: self.view.frame.width*2, height: self.view.frame.height*2)
        
        self.initialCenter = self.dragBtn.center
        
        self.gtLabel.layer.shadowColor = UIColor.white.cgColor
        self.gtLabel.layer.shadowOpacity = 1
        self.gtLabel.layer.shadowOffset = CGSize.init(width: 5, height:5)
        self.gtLabel.layer.shadowRadius = 10
        
        self.webView.delegate = self
        self.webView.scalesPageToFit = true
        
        self.dragBtn.addBlurEffect()
        self.dragBtn.updateMaskForView(text: "Drag Me")
        
        self.entryBtn.addBlurEffect()
        self.entryBtn.maskBlur()
        
        self.dragBtn.addTarget(self, action: #selector(wasDragged(btn:event:)), for: UIControlEvents.touchDragInside)
        self.dragBtn.addTarget(self, action: #selector(beganDrag(btn:event:)), for: UIControlEvents.touchDown)
        self.dragBtn.addTarget(self, action: #selector(exitDrag(btn:event:)), for: UIControlEvents.touchUpInside)
        
        self.maskRespectToButton(viewToMask: self.switchBtnContainer, maskRect: self.dragBtn.bounds, invert: true)
        
        webView.alpha = 0.0
        loadHtmlFile()
        
        loadCoreMotion()
        
        _ = Timer.scheduledTimer(withTimeInterval: 4.8, repeats: true) { (timer: Timer) in
            self.animateArrows()
        }
    }
    
    // MARK: - button options
    
    func maskRespectToButton(viewToMask: UIView, maskRect: CGRect, invert: Bool = false) {
        let radius = maskRect.size.width/2 + 2
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.switchBtnContainer.bounds.size.width, height: self.switchBtnContainer.bounds.size.height), cornerRadius: 0)
        print(self.dragBtn.frame.origin.x)
        print(self.dragBtn.frame.origin.y - viewToMask.frame.origin.y)
        var circleX = self.dragBtn.frame.origin.x - 2
        let circleY = abs(self.dragBtn.frame.origin.y - viewToMask.frame.origin.y) - 2
        var circlePath = UIBezierPath(roundedRect: CGRect(x: circleX, y: circleY, width: 2 * radius, height: 2 * radius), cornerRadius: radius)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        circleX = viewToMask.frame.width - self.dragBtn.frame.width - self.dragBtn.frame.origin.x - 2
        circlePath = UIBezierPath(roundedRect: CGRect(x: circleX, y: circleY, width: 2 * radius, height: 2 * radius), cornerRadius: radius)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.white.cgColor
        fillLayer.opacity = 0.24
        viewToMask.layer.addSublayer(fillLayer)
    }
    
    public func platform() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    public var hasHapticFeedback: Bool {
        return ["iPhone9,1", "iPhone9,3", "iPhone9,2", "iPhone9,4"].contains(platform())
    }
    
    func beganDrag(btn : UIButton, event :UIEvent)
    {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        AudioServicesPlaySystemSound(1306)
    }
    
    func exitDrag(btn : UIButton, event :UIEvent)
    {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        
        if validateDelta() {
            AudioServicesPlaySystemSound(1305)
        }
        else {
            guard let bundle = Bundle.main.path(forResource: "audio/Pop", ofType: "aiff") else {return}
            let alertSound = URL(fileURLWithPath: bundle)
            
            try! audioPlayer = AVAudioPlayer(contentsOf: alertSound)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 0.1
            audioPlayer.play()
        }
        
    }
    
    func validateDelta() -> Bool {
        if(self.dragBtn.frame.intersects(self.entryBtn.frame)) {
            UIView.animate(withDuration: 0.48, animations: {
                self.dragBtn.center = self.entryBtn.center
            })
            return true
        }
        else {
            UIView.animate(withDuration: 0.48, animations: {
                guard let center = self.initialCenter else {return}
                self.dragBtn.center = center
            })
            return false
        }
    }
    
    func wasDragged (btn : UIButton, event :UIEvent)
    {
        print("Dragging")
        guard let touch = event.touches(for: btn)?.first else {return}
        
        let previousLocation : CGPoint = touch .previousLocation(in: btn)
        let location : CGPoint = touch .location(in: btn)
        let delta_x :CGFloat = location.x - previousLocation.x
        let delta_y :CGFloat = location.y - previousLocation.y
        btn.center = CGPoint(x: btn.center.x + delta_x,
                               y: btn.center.y + delta_y)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
        override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - animation
    func animateArrows() {
        self.arrowOne.alpha = 0.1
        self.arrowTwo.alpha = 0.1
        self.arrowThree.alpha = 0.1
        
        UIView.animate(withDuration: 0.64, animations: {
            self.arrowOne.alpha = 0.48
        }) { (finish: Bool) in
            UIView.animate(withDuration: 1.04, animations: {
                self.arrowOne.alpha = 0.1
            })
        }
        UIView.animate(withDuration: 0.84, animations: {
            self.arrowTwo.alpha = 0.48
        }) { (finish: Bool) in
            UIView.animate(withDuration: 0.84, animations: {
                self.arrowTwo.alpha = 0.1
            })
        }
        UIView.animate(withDuration: 1.04, animations: {
            self.arrowThree.alpha = 0.48
        }) { (finish: Bool) in
            UIView.animate(withDuration: 0.64, animations: {
                self.arrowThree.alpha = 0.1
            })
        }
    }
    
    // MARK: - parallax
    func loadCoreMotion() {
        let manager = CMMotionManager()
        if(manager.isGyroAvailable && !manager.isGyroActive) {
            manager.gyroUpdateInterval = 0.5
            manager.startGyroUpdates(to: .main, withHandler: { (data: CMGyroData?, error: Error?) in
                guard let gyroData = data else {return}
                let js = String(format: "parallax.onDeviceOrientation({beta:%f, gamma:%f})", arguments: [gyroData.rotationRate.x, gyroData.rotationRate.y])
                self.webView.stringByEvaluatingJavaScript(from: js)
                
                let screenSize = UIScreen.main.bounds
                let screenWidth = screenSize.width
                let screenHeight = screenSize.height
                
                let js2 = String(format: "document.getElementById('scene').setAttribute('style', 'width:%f; height: %f;')", arguments: [screenWidth, screenHeight])
                self.webView.stringByEvaluatingJavaScript(from: js2)
            })
        }
    }

    func loadHtmlFile() {
        guard let url = Bundle.main.url(forResource: "parallax", withExtension:"html") else {print("Returned Bundle");return}
        
        let request = URLRequest(url: url)
        
        webView.alpha = 0.0
        
        webView.loadRequest(request)
    }
}

extension ViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView.scrollView.contentInset = UIEdgeInsets.zero
        self.webView.isOpaque = false
        
        let rect = CGRect(x: self.webView.scrollView.contentSize.width/8, y: self.webView.scrollView.contentSize.height/3, width: self.webView.scrollView.contentSize.width/2, height: self.webView.scrollView.contentSize.height/2)
        self.webView.scrollView.zoom(to: rect, animated: false)
//        self.webView.isUserInteractionEnabled = false
        UIView.animate(withDuration: 1.48) {
            webView.alpha = 1.0
        }
    }
}



