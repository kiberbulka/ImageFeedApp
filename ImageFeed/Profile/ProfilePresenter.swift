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
    func notificationObserver()
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    private var profileObserver: NSObjectProtocol?
    
    init(view:ProfileViewControllerProtocol?){
        self.view = view
        notificationObserver()
    }
    
    func viewDidLoad() {
        notificationObserver()
        guard let profile = ProfileService.shared.profile else {return}
        view?.updateUserProfile(name: profile.name, loginName: profile.loginName, bio: profile.bio)
    }
    
    func notificationObserver() {
        profileObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                self?.view?.updateAvatar()
            }
    }
    
    func logout() {
        ProfileLogoutService.shared.logout()
    }
    
  
    
    
}


