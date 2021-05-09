//
//  SettingsTableViewCell.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/6/21.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    static let identifier = "SettingsTableViewCell"
    
    public func setUp(with viewModel: SettingsViewModel) {
        self.textLabel?.text = viewModel.title
        switch viewModel.viewModelType {
        case .setting:
            textLabel?.textAlignment = .left
            selectionStyle = .default
            textLabel?.textColor = .white
        case .logout:
            textLabel?.textColor = .red
            textLabel?.textAlignment = .center
            selectionStyle = .default
        }
    }

}
