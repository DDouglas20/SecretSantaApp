//
//  settingsVCViewModel.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/6/21.
//

import Foundation

public enum SettingsViewModelType {
    case setting, logout
}

struct SettingsViewModel {
    let viewModelType: SettingsViewModelType
    let title: String
    let handler: (() -> Void)?
}
