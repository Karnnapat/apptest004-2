//
//  InteractiveModalPresentationController.swift
//  LUMPSUM
//
//  Created by Kritsanun Wisessuk on 29/8/2566 BE.
//  Copyright © 2566 BE OnlineAsset. All rights reserved.
//
// Ref From : iOS UIKit: How to create custom modal presentation style by Maksim Vialykh

import Foundation
import UIKit

enum ModalScaleState {
    case presentation
    case interaction
}

final class InteractiveModalTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactiveDismiss = true
    
    init(from presented: UIViewController, to presenting: UIViewController) {
        super.init()
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
}

final class InteractiveModalPresentationController: UIPresentationController {
    
    private let presentedYOffset: CGFloat = 150
    private var direction: CGFloat = 0
    private var state: ModalScaleState = .interaction
    private lazy var dimmingView: UIView! = {
        guard let container = containerView else { return nil }
        
        let view = UIView(frame: container.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(didTap(tap:)))
        )
        
        return view
    }()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.view.layer.cornerRadius = 13
        presentedViewController.view.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(didPan(pan:)))
        )
    }
    
    @objc func didPan(pan: UIPanGestureRecognizer) {
        guard let view = pan.view, let superView = view.superview,
              let presented = presentedView, let container = containerView else { return }
        
        let location = pan.translation(in: superView)
        
        switch pan.state {
        case .began:
            presented.frame.size.height = container.frame.height
        case .changed:
            let velocity = pan.velocity(in: superView)
            
            switch state {
            case .interaction:
                presented.frame.origin.y = location.y + presentedYOffset
            case .presentation:
                presented.frame.origin.y = location.y
            }
            direction = velocity.y
        case .ended:
            let maxPresentedY = (container.frame.height/2)
            switch presented.frame.origin.y {
            case (presentedYOffset - 50)...maxPresentedY:
                changeScale(to: .interaction)
//                presentedViewController.dismiss(animated: true, completion: nil)
            default:
                presentedViewController.dismiss(animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    @objc func didTap(tap: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    func changeScale(to state: ModalScaleState) {
        guard let presented = presentedView else { return }
        
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: { [weak self] in
            guard let `self` = self else { return }
            
            presented.frame = self.frameOfPresentedViewInContainerView
            
        }, completion: { (isFinished) in
            self.state = state
        })
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        
        return CGRect(x: 0, y: self.presentedYOffset, width: container.bounds.width, height: container.bounds.height - self.presentedYOffset)
    }
    
    override func presentationTransitionWillBegin() {
        guard let container = containerView,
              let coordinator = presentingViewController.transitionCoordinator else { return }
        
        dimmingView.alpha = 0
        container.addSubview(dimmingView)
        dimmingView.addSubview(presentedViewController.view)
        
        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let `self` = self else { return }
            
            self.dimmingView.alpha = 1
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: { [weak self] (context) -> Void in
            guard let `self` = self else { return }
            
            self.dimmingView.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
}
