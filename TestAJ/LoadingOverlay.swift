//
//  LoadingOverlay.swift
//  KitchenLogs
//
//  Created by Pankaj Bhardwaj on 27/07/17.
//  Copyright © 2017 . All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlay {
    
    var overlayView : UIView?
    var toastLabel : UILabel?
    var activityIndicator : UIActivityIndicatorView?
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    init(){
        self.overlayView = UIView()
        self.activityIndicator = UIActivityIndicatorView()
        overlayView?.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        overlayView?.backgroundColor = .black
        overlayView?.layer.zPosition = 1
        overlayView?.alpha = 0.7
        
        activityIndicator?.frame = CGRect(x: screenSize.width/2 - 20, y: screenSize.height/2 - 20, width: 40, height: 40)
        activityIndicator?.center = CGPoint(x: (overlayView?
            .bounds.width)! / 2, y: (overlayView?.bounds.height)! / 2)
        activityIndicator?.activityIndicatorViewStyle = .whiteLarge
        activityIndicator?.color = .gray
        
        self.toastLabel = UILabel(frame: CGRect(x: 20, y: screenSize.height/2 - 60, width: screenSize.width - 40, height: 30))
        self.toastLabel?.backgroundColor = UIColor.clear
        self.toastLabel?.textColor = UIColor.white
        self.toastLabel?.textAlignment = .center;
        self.toastLabel?.font = UIFont(name: "Montserrat-Regular", size: 10.0)
        self.toastLabel?.text = ""
        self.toastLabel?.alpha = 1.0
        self.toastLabel?.layer.cornerRadius = 30;
        self.toastLabel?.clipsToBounds  =  true
        overlayView?.addSubview(toastLabel ?? UILabel())
        
        overlayView?.addSubview(activityIndicator ?? UIActivityIndicatorView())
    }
    
    public func showOverlay(view: UIView , msg:String) {
        overlayView?.center = view.center
        self.toastLabel?.text = msg
        view.addSubview(overlayView ?? UIView())
        activityIndicator?.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator?.stopAnimating()
        overlayView?.removeFromSuperview()
    }
}
