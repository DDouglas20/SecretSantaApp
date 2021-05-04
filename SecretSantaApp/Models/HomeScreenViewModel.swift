//
//  HomeScreenViewModel.swift
//  SecretSantaApp
//
//  Created by DeQuan Douglas on 5/4/21.
//

import Foundation

public enum HomeScreenViewModelType {
    case section, group
}

struct HomeScreenViewModel {
    let viewModelType: HomeScreenViewModelType
    let title: String
    let handler: (() -> Void)?
}
