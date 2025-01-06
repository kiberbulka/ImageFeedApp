//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Olya on 26.10.2024.
//

import UIKit
final class ImagesListCell: UITableViewCell{
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    func configure(with photo: Photo) {
            dateLabel.text = photo.createdAt.map { DateFormatter.localizedString(from: $0, dateStyle: .medium, timeStyle: .none)} ?? "No Date"
            let placeholderImage = UIImage(named: "placeholder")
            cellImage.kf.indicatorType = .activity
            
            if let url = URL(string: photo.thumbImageURL) {
                cellImage.kf.setImage(
                    with: url,
                    placeholder: placeholderImage,
                    options: nil,
                    completionHandler: {[weak self] result in
                        guard let self = self else { return }
                        switch result {
                        case .success:
                            self.setNeedsLayout()
                        case .failure:
                            print("Image loadimg failed")
                        }
                    }
                )
            }
        }
        override func prepareForReuse() {
            super.prepareForReuse()
            cellImage.kf.cancelDownloadTask()
            cellImage.image = nil
            dateLabel.text = nil
        }
}
