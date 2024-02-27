//
//  LoadingOverlay.swift
//  LFPCenter
//
//  Created by IT-EFW-65-03 on 18/5/2566 BE.
//

import Foundation
import UIKit

public class LoadingOverlay{
    
    var viewBG = UIView()
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
        viewBG.removeFromSuperview()
        
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        guard let window = firstScene.windows.first else {
            return
        }
        
        window.viewWithTag(101)?.removeFromSuperview()
    }
    
    public func showOverlay() {
        guard let firstScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        guard let window = firstScene.windows.first else {
            return
        }
        
        viewBG = UIView(frame: window.frame)
        let blurEffect = UIBlurEffect(style: .systemChromeMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = window.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewBG.addSubview(blurEffectView)
        
        overlayView.frame = CGRectMake(0, 0, 80, 80)
        overlayView.center = CGPointMake(window.frame.width / 2.0, window.frame.height / 2.0)
        overlayView.backgroundColor = .lightGray
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.style = .medium
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        viewBG.addSubview(overlayView)
        viewBG.tag = 101
        window.addSubview(viewBG)
        
        activityIndicator.startAnimating()
        
    }
}
