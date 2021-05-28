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
    // MARK: Failure Alerts
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
    
    func couldNotDeleteGroup() {
        let alert = UIAlertController(title: "Error",
                                      message: "Could not delete group. Please try again",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    func groupCreated() {
        let alert = UIAlertController(title: "Group Created",
                                      message: "Group Successfully Created",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: { [weak self] _ in
                                        self?.navigationController?.popViewController(animated: true)
                                      }))
        present(alert, animated: true)
    }
    
    func maxRoomsCreated() {
        let alert = UIAlertController(title: "Limit Reached",
                                      message: "You Have Created the Max Number of Groups Allowed",
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
    
    func notEnoughUsers() {
        let alert = UIAlertController(title: "Error",
                                      message: "You need 3 or more group members to begin",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func groupIDCopied() {
        let alert = UIAlertController(title: "Copied!",
                                      message: "Successfully copied groupID",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func couldNotAddItem() {
        let alert = UIAlertController(title: "Error", message: "Could Not Add Gift", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func couldNotDeleteItem() {
        let alert = UIAlertController(title: "Error",
                                      message: "Could not delete gift. Please try again in a few moments",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteGroupWarning(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Warning",
                                      message: "Are You Sure You Want to Delete the Group?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completion(false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func deletedGroup() {
        let alert = UIAlertController(title: "Done", message: "Successfully Deleted Group", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { [weak self] _ in
            self?.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func leaveGroupWarning(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Warning",
                                      message: "Are You Sure You Want to Leave the Group?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Leave", style: .destructive, handler: { _ in
            completion(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            completion(false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func joinGroupFieldEmpty() {
        let alert = UIAlertController(title: "Error", message: "Field is Empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func joinedGroup() {
        let alert = UIAlertController(title: "Success", message: "Successfully Joined Group", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            strongSelf.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func couldNotJoinGroup() {
        let alert = UIAlertController(title: "Error", message: "Please Make Sure You Have the Correct GroupID", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func userExistsInGroup() {
        let alert = UIAlertController(title: "Error", message: "You Have Already Joined This Group", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func logOut(completion: @escaping (Bool) -> Void) {
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
                                                    completion(true)
                                                }
                                                catch {
                                                    print("Could not log out")
                                                    completion(false)
                                                }
                                                
                                            }))
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        present(actionSheet, animated: true)
    }
    
    // MARK: Success Alerts
    func successfullyAddedGroup() {
        let alert = UIAlertController(title: "Success!", message: "Successfully Created Group", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
