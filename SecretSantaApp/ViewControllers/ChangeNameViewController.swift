//
//  ChangeNameViewController.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/11/21.
//

import UIKit

class ChangeNameViewController: UIViewController {
    
    private let changeNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Edit Name"
        label.font = .boldSystemFont(ofSize: 30)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    private let changeNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .black
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.autocapitalizationType = .allCharacters
        textField.returnKeyType = .done
        textField.autocorrectionType = .no
        textField.textColor = .white
        
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        // Add subviews
        view.addSubview(changeNameLabel)
        
        
        
    }
    

}

extension ChangeNameViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let rawString = string
        let range = rawString.rangeOfCharacter(from: .whitespaces)
        if ((textField.text?.count)! == 0 && range != nil) || ((textField.text?.count)! > 0 && textField.text?.last == " " && range != nil) {
            return false
        }
        
        return true
    }
}
