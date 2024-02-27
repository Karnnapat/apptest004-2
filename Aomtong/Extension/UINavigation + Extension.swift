//
//  UINavigation + Extension.swift
//  Aomtong
//
//  Created by Karnnapat Kamolwisutthipong on 17/1/2567 BE.
//

import Foundation
import UIKit

extension UINavigationController : UIGestureRecognizerDelegate {
    func popToViewController(ofClass : AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass )}) {
            popToViewController(vc, animated: animated)
        }
    }
}
