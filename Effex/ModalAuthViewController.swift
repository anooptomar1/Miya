//
//  ModalAuthViewController.swift
//  Effex
//
//  Created by Steven Hurtado on 8/9/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

protocol ModalAuthViewControllerDelegate: class {
    func authorized(sender: ModalAuthViewController)
}

class ModalAuthViewController: UIViewController {

    @IBOutlet weak var modalView: UIView!
    @IBOutlet weak var touchBtn: BlurButton!
    weak var delegate : ModalAuthViewControllerDelegate?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.modalView.layer.cornerRadius = 4
        self.touchBtn.layer.cornerRadius = self.touchBtn.frame.size.width / 2
        
        self.touchBtn.addBlurEffect(withStyle: .dark)
        self.touchBtn.updateMaskForView(text: "Touch")
        
//        self.touchBtn.maskBlur()
        self.touchBtn.indicator.color = UIColor.white
    }

    @IBAction func touched(_ sender: Any) {
        self.touchBtn.load()
        
        let delayInSeconds = 1.48
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.dismiss(animated: true) {
                self.delegate?.authorized(sender: self)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
