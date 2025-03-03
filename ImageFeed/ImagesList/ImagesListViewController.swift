//
//  ViewController.swift
//  ImageFeed
//
//  Created by Olya on 26.10.2024.
//

import UIKit
import Kingfisher
import ProgressHUD

final class ImagesListViewController: UIViewController {
    
    
    // MARK: - IB Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private var photos = [Photo]()
    private let imagesListService = ImagesListService.shared
    private let showSingleImageSegueidentifier = "ShowSingleImage"
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Initializers
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil)
        
        imagesListService.fetchPhotosNextPage()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueidentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let photo = photos[indexPath.row]
            if let largeImageURLString = photo.largeImageURL,
               let url = URL(string: largeImageURLString) {
                viewController.imageUrl = url
            } else {
                print("Invalid URL string: \(photo.largeImageURL)")
            }
        }
    }
    
    @objc private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newPhotos = imagesListService.photos
        let newCount = newPhotos.count
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                photos = newPhotos  // Обновляем данные внутри performBatchUpdates
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        return ImagesListViewController.dateFormatter.string(from: date)
    }
}
// MARK: - Extensions

extension ImagesListViewController:UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        let photo = photos[indexPath.row]
        imageListCell.configure(with: photo, tableView: tableView, for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        
        return imageListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let width = tableView.bounds.width - 32
        return width * photo.aspectRatio + 16
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueidentifier, sender: indexPath)
        let photo = photos[indexPath.row]
        guard let fullImageUrlString = photo.largeImageURL,
              let fullImageUrl = URL(string: fullImageUrlString) else { return }
        let detailVC = SingleImageViewController()
        detailVC.imageUrl = fullImageUrl
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.photos[indexPath.row].isLiked.toggle()
                    //guard let photos = self?.imagesListService.photos else { return }
                    cell.setIsLiked(self?.photos[indexPath.row].isLiked ?? false)
                    UIBlockingProgressHUD.dismiss()
                case .failure(let error):
                    UIBlockingProgressHUD.dismiss()
                    let alert = UIAlertController(title: "Что-то пошло не так", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default)
                    alert.addAction(action)
                }
            }
        }
    }
    
    
    
}



