//
//  HomeScreenTableViewCell.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/4/21.
//

import UIKit

class HomeScreenTableViewCell: UITableViewCell {

    static let identifier = "HomeScreenTableViewCell"
    
    public func setUp(with viewModel: HomeScreenViewModel) {
        self.textLabel?.text = viewModel.title
        switch viewModel.viewModelType {
        case .section:
            textLabel?.textAlignment = .left
            selectionStyle = .none
        case .group:
            textLabel?.textAlignment = .left
            selectionStyle = .default
        }
    }

}
