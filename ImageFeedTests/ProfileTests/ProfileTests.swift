//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Olya on 07.03.2025.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {

        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        presenter.viewDidLoad()

        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerCallsNotificationObserver() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.notificationObserver()
        
        XCTAssertTrue(presenter.notificationObserverCalled)
    }
}
