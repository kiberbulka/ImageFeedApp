//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Olya on 26.10.2024.
//

import UIKit
protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
final class ImagesListCell: UITableViewCell {
    
    static let dateFormatter: DateFormatter = {
          let dateFormatter = DateFormatter()
          dateFormatter.dateStyle = .medium
          dateFormatter.timeStyle = .none
          return dateFormatter
      }()
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    func configure(with photo: Photo, tableView: UITableView, for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let imageUrlString = photo.thumbImageURL,
              let imageUrl = URL(string: imageUrlString) else { return }
        
        cell.cellImage.kf.indicatorType = .activity
        
        cell.cellImage.kf.setImage(with: imageUrl,
                                   placeholder: UIImage(named: "placeholder")) { _ in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }

        guard let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off") else { return }
        cell.likeButton.setImage(likeImage, for: .normal)
        
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)

        guard let photoCreatedAt = photo.createdAt else { return }
        let date = ImagesListCell.dateFormatter.string(from: photoCreatedAt)
        cell.dateLabel.text = date
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
        dateLabel.text = nil
        likeButton.setImage(nil, for: .normal)
    }
    
    @objc private func likeButtonClicked(){
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    func updateCell(dateLabel: String, likeButton: String, cellImage: UIImageView){
        DispatchQueue.main.async {
            self.dateLabel.text = dateLabel
            self.likeButton.setTitle(likeButton, for: .normal)
            self.cellImage.image = self.imageView?.image
        }
    }
}
