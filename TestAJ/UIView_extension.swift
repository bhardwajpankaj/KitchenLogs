//
//  UIView_extension.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 23/07/17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import UIKit

private let UIViewVisibilityShowAnimationKey = "UIViewVisibilityShowAnimationKey"
private let UIViewVisibilityHideAnimationKey = "UIViewVisibilityHideAnimationKey"


private class UIViewAnimationDelegate: NSObject {
    weak var view: UIView?
    
    dynamic func animationDidStop(animation: CAAnimation, finished: Bool) {
        guard let view = self.view, finished else {
            return
        }
        
        view.isHidden = !view.visible
        view.removeVisibilityAnimations()
    }
}


extension UIView {
    
    func removeVisibilityAnimations() {
        self.layer.removeAnimation(forKey: UIViewVisibilityShowAnimationKey)
        self.layer.removeAnimation(forKey: UIViewVisibilityHideAnimationKey)
    }
    
    var visible: Bool {
        get {
            return !self.isHidden && self.layer.animation(forKey: UIViewVisibilityHideAnimationKey) == nil
        }
        
        set {
            let visible = newValue
            
            guard self.visible != visible else {
                return
            }
            
            let animated = UIView.areAnimationsEnabled
            
            self.removeVisibilityAnimations()
            
            guard animated else {
                self.isHidden = !visible
                return
            }
            
            self.isHidden = false
            
            let delegate = UIViewAnimationDelegate()
            delegate.view = self
            
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = visible ? 0.0 : 1.0
            animation.toValue = visible ? 1.0 : 0.0
            animation.fillMode = kCAFillModeForwards
            animation.isRemovedOnCompletion = false
            animation.delegate = delegate as? CAAnimationDelegate
            
            self.layer.add(animation, forKey: visible ? UIViewVisibilityShowAnimationKey : UIViewVisibilityHideAnimationKey)
        }
    }
    
    func setVisible(visible: Bool, animated: Bool) {
        let wereAnimationsEnabled = UIView.areAnimationsEnabled
        
        if wereAnimationsEnabled != animated {
            UIView.setAnimationsEnabled(animated)
            defer { UIView.setAnimationsEnabled(!animated) }
        }
        
        self.visible = visible
    }
    
}
