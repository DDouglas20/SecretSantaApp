//
//  AlertFunctions.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 4/26/21.
//

import Foundation
import UIKit
import FirebaseAuth

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
    
    func maxRoomsCreated() {
        let alert = UIAlertController(title: "Limit Reached",
                                      message: "You Have Created the Max Number of Groups",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
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
    
    func logOut() {
        let actionSheet = UIAlertController(title: "Log Out",
                                      message: "Are you sure you want to logout?",
                                      preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive,
                                            handler: { [weak self] _ in
                                                
                                                // Log out of firebase
                                                do {
                                                    try FirebaseAuth.Auth.auth().signOut()
                                                    
                                                    let vc = LoginViewController()
                                                    let nav = UINavigationController(rootViewController: vc)
                                                    nav.modalPresentationStyle =  .fullScreen
                                                    self?.present(nav, animated: true)
                                                }
                                                catch {
                                                    print("Could not log out")
                                                }
                                                
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        present(actionSheet, animated: true)
    }
}
