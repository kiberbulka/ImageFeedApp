//
//  ImagesListPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Olya on 07.03.2025.
//

@testable import ImageFeed
import UIKit

final class ImagesListPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var notificationObserverCalled: Bool = false
    var isLiked: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func notificationObserver() {
        notificationObserverCalled = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.isLiked = isLike
            completion(.success(()))
        }
    }
    
    
}
