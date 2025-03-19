//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Olya on 07.03.2025.
//

@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImageFeed.ImagesListViewPresenterProtocol?
    var tableViewUpdatesCalled: Bool = false
    
    func updateTableViewAnimated() {
        tableViewUpdatesCalled = true
    }
    
    
}
