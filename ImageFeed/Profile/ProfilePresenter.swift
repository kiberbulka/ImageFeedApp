//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Olya on 07.03.2025.
//

import Foundation

public protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? {get set}
    func viewDidLoad()
    func logout()
}


