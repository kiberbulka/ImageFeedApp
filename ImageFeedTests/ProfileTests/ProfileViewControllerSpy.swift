//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Olya on 07.03.2025.
//

@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: (any ImageFeed.ProfilePresenterProtocol)?
    
    func updateUserProfile(name: String, loginName: String, bio: String?) {
    }
    
    func updateAvatar() {
    }
    
 
}
