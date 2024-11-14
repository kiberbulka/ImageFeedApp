//
//  ViewController.swift
//  ImageFeed
//
//  Created by Olya on 26.10.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    // MARK: - IB Outlets
    
    @IBOutlet private var tableView: UITableView!
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    private let showSingleImageSegueidentifier = "ShowSingleImage"
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - Initializers
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
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

                    let image = UIImage(named: photosName[indexPath.row])
                    viewController.image = image
                } else {
                    super.prepare(for: segue, sender: sender)
                }
        }

    
    // MARK: - IB Action
    
    // MARK: - Public Methods
    
    
    
    // MARK: - Private Methods
    
}
    // MARK: - Extensions

extension ImagesListViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: showSingleImageSegueidentifier, sender: indexPath)
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        guard imageWidth != 0 else {
            let scale = imageViewWidth / 1
            let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
            return cellHeight
        }
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
}
extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath){
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        cell.cellImage.image = image
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = indexPath.row % 2 == 0
        let likeImage = isLiked ? UIImage(named: "like_button_on") :
            UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
}



