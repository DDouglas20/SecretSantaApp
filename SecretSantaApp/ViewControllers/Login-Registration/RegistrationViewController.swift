//
//  RegistrationViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 4/24/21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegistrationViewController: UIViewController {
    
    private let loadingSpinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.autocapitalizationType = .none
        emailField.layer.cornerRadius = 12
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.backgroundColor = .darkGray
        emailField.textColor = .white
        emailField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        emailField.leftViewMode = .always
        
        return emailField
    }()
    
    private let nameField: UITextField = {
        let nameField = UITextField()
        nameField.autocorrectionType = .no
        nameField.returnKeyType = .continue
        nameField.layer.cornerRadius = 12
        nameField.layer.borderWidth = 1
        nameField.layer.borderColor = UIColor.lightGray.cgColor
        nameField.backgroundColor = .darkGray
        nameField.textColor = .white
        nameField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        nameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        nameField.leftViewMode = .always
        
        return nameField
    }()
    
    private let passField: UITextField = {
        let passField = UITextField()
        passField.autocorrectionType = .no
        passField.returnKeyType = .continue
        passField.layer.cornerRadius = 12
        passField.layer.borderWidth = 1
        passField.layer.borderColor = UIColor.lightGray.cgColor
        passField.backgroundColor = .darkGray
        passField.textColor = .white
        passField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passField.leftViewMode = .always
        passField.isSecureTextEntry = true
        
        return passField
    }()
    
    private let passConfirmField: UITextField = {
        let passConfirmField = UITextField()
        passConfirmField.autocorrectionType = .no
        passConfirmField.returnKeyType = .done
        passConfirmField.layer.cornerRadius = 12
        passConfirmField.layer.borderWidth = 1
        passConfirmField.layer.borderColor = UIColor.lightGray.cgColor
        passConfirmField.backgroundColor = .darkGray
        passConfirmField.textColor = .white
        passConfirmField.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passConfirmField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passConfirmField.leftViewMode = .always
        passConfirmField.isSecureTextEntry = true
        
        return passConfirmField
    }()
    
    private let registerButton: UIButton = {
       let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGray2
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Subviews
        view.addSubview(scrollView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(nameField)
        scrollView.addSubview(passField)
        scrollView.addSubview(passConfirmField)
        scrollView.addSubview(registerButton)
        
        scrollView.isUserInteractionEnabled = true
        
        // Delegates
        emailField.delegate = self
        nameField.delegate = self
        passField.delegate = self
        passConfirmField.delegate = self
        
        // Dismiss keyboard on screen touch
        dismissKeyboardOnScreenTap()
        
        // Buttons
        registerButton.addTarget(self,
                                 action: #selector(registerButtonTapped),
                                 for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        
        emailField.frame = CGRect(x: view.left + 30,
                                 y: 50,
                                 width: scrollView.width - 60,
                                 height: 50)
        nameField.frame = CGRect(x: view.left + 30,
                                 y: emailField.bottom + 20,
                                 width: scrollView.width - 60,
                                 height: 50)
        passField.frame = CGRect(x: view.left + 30,
                                 y: nameField.bottom + 20,
                                 width: scrollView.width - 60,
                                 height: 50)
        passConfirmField.frame = CGRect(x: view.left + 30,
                                        y: passField.bottom + 20,
                                        width: scrollView.width - 60,
                                        height: 50)
        registerButton.frame = CGRect(x: view.left + 50,
                                      y: passConfirmField.bottom + 20,
                                      width: scrollView.width - 100,
                                      height: 50)
    }

}

// MARK: Functions

extension RegistrationViewController: UITextFieldDelegate {
    
    @objc private func registerButtonTapped() {
        
        // Dismiss keyboard when tapped
        emailField.resignFirstResponder()
        nameField.resignFirstResponder()
        passField.resignFirstResponder()
        passConfirmField.resignFirstResponder()
        
        // Make sure users conform to what's needed
        guard let email = emailField.text,
              let name = nameField.text,
              let pass = passField.text,
              let passConfirm = passConfirmField.text,
              !email.isEmpty,
              !name.isEmpty,
              !pass.isEmpty,
              !passConfirm.isEmpty,
              passwordsDidNotMatch(pass: pass, passConfirm: passConfirm) else {
                return alertUserRegistrationisEmpty()
        }
        
        // Show spinner
        loadingSpinner.show(in: view)
        
        // Register User
        let fireBaseEmail = DatabaseManager.firebaseEmail(emailAddress: email)
        DatabaseManager.shared.userExists(with: fireBaseEmail, completion: { [weak self] exists in
            
            DispatchQueue.main.async {
                self?.loadingSpinner.dismiss()
            }
            
            guard !exists else {
                // User already exists
                self?.userExistsError()
                return
            }
            
            print("This is email: \(email)")
            print("This is password: \(pass)")
            
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: pass, completion: { authResult, error in
                guard authResult != nil, error == nil else {
                    //print("This is result: \(authResult)")
                    print("This is error: \(error)")
                    print("Could not create user")
                    return
                }
                
                
                DatabaseManager.shared.insertUserInfo(withemail: fireBaseEmail, name: name, completion: { [weak self] success in
                    if success {
                        print("Successfully inserted user into database")
                        UserDefaults.standard.setValue(fireBaseEmail, forKey: "email")
                        self?.navigationController?.dismiss(animated: true, completion: nil)
                    }
                    else {
                        self?.couldNotRegisterUser()
                        return
                    }
                })
                
            })
            
            
        })
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            nameField.becomeFirstResponder()
        }
        else if textField == nameField {
            passField.becomeFirstResponder()
        }
        else if textField == passField {
            passConfirmField.becomeFirstResponder()
        }
        
        else if textField == passConfirmField {
            registerButtonTapped()
        }
        
        return true
    }
    
}
