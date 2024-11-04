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
}
