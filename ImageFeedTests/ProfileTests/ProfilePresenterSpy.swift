//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Olya on 07.03.2025.
//

@testable import ImageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
   
    
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var notificationObserverCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func notificationObserver() {
        notificationObserverCalled = true
    }
    
    func logout() {
    }
    
}
