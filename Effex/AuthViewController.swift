//
//  AuthViewController.swift
//  Effex
//
//  Created by Steven Hurtado on 8/9/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController
{
    @IBOutlet weak var titleButton: BlurButton!
    let transition = DotAnimator()
    
    override func viewDidLoad() {
        
        self.titleButton.addBlurEffect(withStyle: .dark)
        self.titleButton.updateMaskForView(text: "Miya")
        self.titleButton.isUserInteractionEnabled = false
    }
    
    @IBAction func authFacebook(_ sender: Any) {
    }
    
    
    @IBAction func authGoogle(_ sender: Any) {
    }
    
    @IBAction func authTouch(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "modalAuth") as? ModalAuthViewController
        {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
}

extension AuthViewController: ModalAuthViewControllerDelegate {
    func authorized(sender: ModalAuthViewController) {
        print("AUTHORIZED")
        
        self.performSegue(withIdentifier: "authSegue", sender: self)
    }
}

extension AuthViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = view.center
        if let color = self.titleButton.backgroundColor {
            transition.circleColor = color
        }
        else {
            transition.circleColor = .red
        }
        
        return transition
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = view.center
        
        if let color = self.titleButton.backgroundColor {
            transition.circleColor = color
        }
        else {
            transition.circleColor = .red
        }
        
        return transition
    }
}
