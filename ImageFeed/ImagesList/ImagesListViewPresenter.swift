//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Olya on 07.03.2025.
//

import Foundation

public protocol ImagesListViewPresenterProtocol : AnyObject {
    var view: ImagesListViewControllerProtocol? {get set}
    func viewDidLoad()
    func notificationObserver()
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    
    init(view: ImagesListViewControllerProtocol?) {
        self.view = view
    }
    
    func viewDidLoad() {
        notificationObserver()
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    func notificationObserver() {
        NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification,
                                                      object: nil,
                                               queue: .main) { [weak self] _ in
            guard let self = self else { return }
            view?.updateTableViewAnimated()
        }
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, any Error>) -> Void) {
        ImagesListService.shared.changeLike(photoId: photoId, isLike: isLike) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success():
                completion(.success(()))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
