//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Olya on 04.11.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = .ypBlack
        let userPic = UIImage(named: "userPic")
        let avatarImage = UIImageView(image: userPic)
        avatarImage.layer.cornerRadius = 31
        self.view.addSubview(avatarImage)
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalToConstant: 70),
            avatarImage.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 76),
            avatarImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
        ])
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.textColor = .ypWhite
        self.view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16)
        ])
        
        let usernameLabel = UILabel()
        usernameLabel.text = "@ekaterina_nov"
        usernameLabel.font = .systemFont(ofSize: 13)
        usernameLabel.textColor = .ypGray
        self.view.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.numberOfLines = 0
        self.view.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
        ])
        
        let logoutButton = UIButton()
        logoutButton.setImage(UIImage(named:"logout_button"), for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24)
        ])
        
        
        if let profile = ProfileService.shared.profile {
            nameLabel.text = profile.name
            descriptionLabel.text = profile.bio
            usernameLabel.text = profile.username
        }
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        )   {[weak self] _ in
            guard let self = self else { return }
            self.updateAvatar()
        }
        updateAvatar()
    }
    
    private func updateAvatar(){
        guard
            let profileImageUrl = ProfileImageService.shared.avatarUrl,
            let url = URL(string: profileImageUrl)
        else { return }
        
        if let imageView = view.subviews.compactMap( {$0 as? UIImageView}).first {
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "avatar"),
                options: [
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }
    }
}
