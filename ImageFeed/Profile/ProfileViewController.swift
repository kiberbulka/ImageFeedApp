//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Olya on 04.11.2024.
//

import UIKit

final class ProfileViewController: UIViewController {

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
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16)
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
    }
    
    

}
//#Preview("ProfileView") {
    //ProfileViewController()
//}
