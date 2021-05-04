//
//  AlertFunctions.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 4/26/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Error",
                                      message: "Login or Username invalid. Please try again",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    func alertLoginFieldisEmpty() {
        let alert = UIAlertController(title: "Error",
                                      message: "Please Fill Out All Information",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    func alertUserRegistrationisEmpty() {
        let alert = UIAlertController(title: "Error",
                                      message: "Please Fill Out All Information",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    func couldNotRegisterUser() {
        let alert = UIAlertController(title: "Error",
                                      message: "Could Not Register. Please try again",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    func passwordsDidNotMatch(pass: String, passConfirm: String) -> Bool {
        guard pass == passConfirm else {
            let alert = UIAlertController(title: "Error",
                                          message: "Passwords do not match",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss",
                                          style: .cancel,
                                          handler: nil))
            present(alert, animated: true)
            
            return false
        }
        
        return true
    }
    
    func userExistsError() {
        let alert = UIAlertController(title: "Error",
                                      message: "This user already exists",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
        
        
    }
}
