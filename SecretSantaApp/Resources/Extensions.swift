//
//  Extensions.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 4/24/21.
//

import Foundation
import UIKit

extension UIView {
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }
    
    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.size.height + frame.origin.y
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.size.width + frame.origin.x
    }
   
}

extension UIViewController {
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        //print("This function is being called")
    }
    
    func dismissKeyboardOnScreenTap() {
         let tapGesture = UITapGestureRecognizer(target: self,
                                                 action: #selector(UIViewController.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}
