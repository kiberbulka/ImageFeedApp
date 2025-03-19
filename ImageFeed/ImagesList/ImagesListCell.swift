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
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
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
                                   placeholder: UIImage(named: "placeholder"),
                                   options: [.transition(.fade(0.2)), .cacheOriginalImage])
        
        let likeImage = photo.isLiked ? UIImage(named: "like_button_on") : UIImage(named: "like_button_off")
        cell.likeButton.setImage(likeImage, for: .normal)
        
        if let photoCreatedAt = photo.createdAt {
            let date = ImagesListCell.dateFormatter.string(from: photoCreatedAt)
            cell.dateLabel.text = date
        } else {
            cell.dateLabel.text = nil
        }
        
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
    
    override func awakeFromNib() {
          super.awakeFromNib()
          likeButton.accessibilityIdentifier = "like_button"
      }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
        dateLabel.text = nil
        likeButton.setImage(nil, for: .normal)
    }
    
    @objc private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(named: "like_button_on"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like_button_off"), for: .normal)
        }
    }
}

