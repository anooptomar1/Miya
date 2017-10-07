//
//  NavigationControllerDelegate.swift
//  Effex
//
//  Created by Steven Hurtado on 8/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
    
    func navigationController(
        _ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController
        ) -> UIViewControllerAnimatedTransitioning? {
        
        if let source = fromVC as? ViewController {
            
            toVC.transitioningDelegate = source
            toVC.modalPresentationStyle = .custom
            
            if let dest = toVC as? AuthViewController {
                let dotTransition = DotAnimator()
                
                dotTransition.transitionMode = .present
                dotTransition.startingPoint = source.titleLogo.center
                
                if let color = dest.view.backgroundColor {
                    dotTransition.circleColor = color
                }
                
                return dotTransition
            }
        }
        
        if let source = fromVC as? AuthViewController {
            
            toVC.transitioningDelegate = source
            toVC.modalPresentationStyle = .custom
            
            if let dest = toVC as? ARSCNViewController {
                let dotTransition = DotAnimator()
                
                dotTransition.transitionMode = .present
                dotTransition.startingPoint = source.titleButton.center
                
                if let color = dest.view.backgroundColor {
                    dotTransition.circleColor = color
                }
                
                return dotTransition
            }
        }
        
        return FadeAnimator()
    }
}
