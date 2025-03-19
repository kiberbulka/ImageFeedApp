//
//  ImagesListTests.swift
//  ImageFeedTests
//
//  Created by Olya on 07.03.2025.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    
    func testViewControllerCallsViewDidLoad() {
           //Given
           let viewController = ImagesListViewController()
           let presenter = ImagesListPresenterSpy()
           presenter.view = viewController
           viewController.presenter = presenter
           //When
           presenter.viewDidLoad()
           //Then
           XCTAssertTrue(presenter.viewDidLoadCalled)
       }
       
       func testViewControllerCallsNotificationObserver() {
           //Given
           let viewController = ImagesListViewController()
           let presenter = ImagesListPresenterSpy()
           viewController.presenter = presenter
           presenter.view = viewController
           //When
           presenter.notificationObserver()
           //Then
           XCTAssertTrue(presenter.notificationObserverCalled)
       }
       
       func testUpdateTableViewAnimated() {
           //Given
           let viewController = ImagesListViewControllerSpy()
           let presenter = ImagesListPresenterSpy()
           presenter.view = viewController
           viewController.presenter = presenter
           //When
           viewController.updateTableViewAnimated()
           //Then
           XCTAssertTrue(viewController.tableViewUpdatesCalled)
       }
       
       func testChangeLike() {
           //Given
           let expectation = XCTestExpectation(description: "Change like")
           let presenter = ImagesListPresenterSpy()
           //When
           presenter.changeLike(photoId: "PhotoId", isLike: true) { _ in
               expectation.fulfill()
           }
           wait(for: [expectation], timeout: 5)
           //Then
           XCTAssertTrue(presenter.isLiked)
       }
}
