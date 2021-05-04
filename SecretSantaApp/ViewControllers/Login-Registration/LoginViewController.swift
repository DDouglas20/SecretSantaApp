//
//  LoginViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 4/24/21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    
    
    //MARK: View Controller Variables
    private let loadingSpinner = JGProgressHUD(style: .dark)
    
    private let loginStatus = ""
    
    private let SecretSantaLabel: UILabel = {
        let label = UILabel()
        label.text = "Secret Santa"
        //label.font = .italicSystemFont(ofSize: 30)
        label.font = UIFont(name: "Savoye Let", size: 100)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
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
    
    private let passwordField: UITextField = {
        let passField = UITextField()
        passField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passField.layer.cornerRadius = 12
        passField.layer.borderWidth = 1
        passField.isSecureTextEntry = true
        passField.layer.borderColor = UIColor.lightGray.cgColor
        passField.backgroundColor = .darkGray
        passField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        passField.leftViewMode = .always
        
        return passField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 1
        
        return button
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
        
        title = "Log In"
        view.backgroundColor = .black
        
        // Delegates
        emailField.delegate = self
        passwordField.delegate = self
        
        // Add the subviews
        view.addSubview(passwordField)
        view.addSubview(emailField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(logo)
        view.addSubview(SecretSantaLabel)
        
        // Dismiss Keyboard on screen touch
        dismissKeyboardOnScreenTap()
        
        // Set up buttons
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
        registerButton.addTarget(self,
                                 action: #selector(registerButtonTapped),
                                 for: .touchUpInside)
        
        
        

        
    }
    
    override func viewDidLayoutSubviews() {
        // Layout subviews
        super.viewDidLayoutSubviews()
        view.frame = view.bounds
        
        let size = view.width/3
        logo.frame = CGRect(x: (view.width-size)/2,
                            y: 275,
                            width: size,
                            height: size)
        SecretSantaLabel.frame = CGRect(x: view.left,
                                        y:  logo.top - 100,
                                        width: view.width,
                                        height: size)
        emailField.frame = CGRect(x: view.left + 30,
                                 y: logo.bottom + 20,
                                 width: view.width - 60,
                                 height: 50)
        passwordField.frame = CGRect(x: view.left + 30,
                                     y: emailField.bottom + 20,
                                     width: view.width - 60,
                                     height: 50)
        loginButton.frame = CGRect(x: view.left + 50,
                                   y: passwordField.bottom + 20,
                                   width: view.width - 100,
                                   height: 50)
        registerButton.frame = CGRect(x: view.left + 50,
                                      y: loginButton.bottom + 10,
                                      width: view.width - 100,
                                      height: 50)
    }
    


}


//MARK: LoginViewController Functions
extension LoginViewController: UITextFieldDelegate {
    
    @objc private func loginButtonTapped() {
        
        // Dismiss keyboard on tap
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        // Make sure text fields arent empty
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty else {
            alertLoginFieldisEmpty()
            return
        }
        
        loadingSpinner.show(in: view)
        
        // Firebase Log in
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            
            guard let result = authResult, error == nil else {
                print("Could not log in")
                DispatchQueue.main.async {
                    self?.loadingSpinner.dismiss()
                }
                self?.alertUserLoginError()
                return
            }
            
            DispatchQueue.main.async {
                self?.loadingSpinner.dismiss()
            }
            
            let user = result.user
            print("Logged in user: \(user)")
            let fireBaseEmail = DatabaseManager.firebaseEmail(emailAddress: email)
            UserDefaults.standard.setValue(fireBaseEmail, forKey: "email")
            self?.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        // Get information about users groups
        // Get information about users invites
        // Get information about items the user has requested
        
    }
    
    @objc private func registerButtonTapped() {
        
        // Dismiss keyboard on tap
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        // Change view controllers
        let vc = RegistrationViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        if textField == passwordField {
            loginButtonTapped()
        }
        
        return true
    }
    
}
