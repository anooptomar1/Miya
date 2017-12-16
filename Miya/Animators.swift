//
//  Animators.swift
//  Miya
//
//  Created by Steven Hurtado on 8/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class DotAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    // This is used for percent driven interactive transitions, as well as for
    // container controllers that have companion animations that might need to
    // synchronize with the main animation.
    public var circle = UIView()
    
    var startingPoint = CGPoint.zero
    {
        didSet {
            circle.center = startingPoint
        }
    }
    
    var circleColor = UIColor.white
    
    enum CircularTransitionMode : Int {
        case present, dismiss, pop
    }
    
    var transitionMode : CircularTransitionMode = .present
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {return 0.48}
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        let containerView = transitionContext.containerView
        let duration = transitionDuration(using: transitionContext)
        
        if transitionMode == .present {
            if let dest = transitionContext.view(forKey: UITransitionContextViewKey.to) {
                let viewCenter = dest.center
                let viewSize = dest.frame.size
                
                circle = UIView()
                circle.frame = circularFrame(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.width / 2
                circle.center = startingPoint
                
                circle.backgroundColor = circleColor
                circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                
                containerView.addSubview(circle)
            
                dest.center = startingPoint
                dest.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                dest.alpha = 0.0
                
                containerView.addSubview(dest)
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform.identity
                    dest.transform = CGAffineTransform.identity
                    dest.alpha = 1.0
                    dest.center = viewCenter
                }, completion: { finished in
                    let cancelled = transitionContext.transitionWasCancelled
                    transitionContext.completeTransition(!cancelled)
                })
            }
        }
        else {
            let transitionModeKey = (transitionMode == .pop) ? UITransitionContextViewKey.to : UITransitionContextViewKey.from
            
            if let returnView = transitionContext.view(forKey: transitionModeKey)
            {
                let viewCenter = returnView.center
                let viewSize = returnView.frame.size
                
                circle = UIView()
                circle.frame = circularFrame(withViewCenter: viewCenter, size: viewSize, startPoint: startingPoint)
                
                circle.layer.cornerRadius = circle.frame.size.width / 2
                circle.center = startingPoint
                
                UIView.animate(withDuration: duration, animations: {
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returnView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                    returnView.alpha = 0.0
                    returnView.center = self.startingPoint
                    
                    if self.transitionMode == .pop {
                        containerView.insertSubview(returnView, belowSubview: returnView)
                        containerView.insertSubview(self.circle, belowSubview: returnView)
                    }
                }, completion: { finished in
                    
                    returnView.center = viewCenter
                    returnView.removeFromSuperview()
                    
                    self.circle.removeFromSuperview()
                    
                    let cancelled = transitionContext.transitionWasCancelled
                    transitionContext.completeTransition(!cancelled)
                })
            }
        }
    }
    
    func circularFrame(withViewCenter viewCenter: CGPoint, size viewSize: CGSize, startPoint: CGPoint) -> CGRect {
        let xLength = fmax(startPoint.x, viewSize.width - startPoint.x)
        let yLength = fmax(startPoint.y, viewSize.height - startPoint.y)
        
        let offset = sqrt(xLength * xLength + yLength * yLength) * 2
        let size = CGSize(width: offset, height: offset)
        
        return CGRect(origin: CGPoint.zero, size : size)
    }
    
}

class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning
{
    // This is used for percent driven interactive transitions, as well as for
    // container controllers that have companion animations that might need to
    // synchronize with the main animation.
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {return 0.48}
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        let containerView = transitionContext.containerView
        
//        guard let source = transitionContext.viewController( forKey: UITransitionContextViewControllerKey.from) else {return}
        guard let dest = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else {return}
        
        containerView.addSubview(dest.view)
        dest.view.alpha = 0.0
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            dest.view.alpha = 1.0
        }, completion: { finished in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        })
    }
}

