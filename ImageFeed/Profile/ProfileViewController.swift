//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Olya on 04.11.2024.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? {get set}
    func updateUserProfile(name: String, loginName: String, bio: String?)
    func updateAvatar()
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    func updateUserProfile(name: String, loginName: String, bio: String?) {
        nameLabel.text = name
        usernameLabel.text = loginName
        descriptionLabel.text = bio
    }
    
    func updateAvatar(){
        let processor = RoundCornerImageProcessor(cornerRadius: 42)
        guard
            let profileImageUrl = ProfileImageService.shared.avatarUrl,
            let url = URL(string: profileImageUrl)
        else { return }
        
        if let imageView = view.subviews.compactMap( {$0 as? UIImageView}).first {
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "avatar"),
                options: [
                    .processor(processor),
                    .transition(.fade(0.2)),
                    .cacheOriginalImage
                ]
            )
        }
    }

    private lazy var userPic: UIImageView = {
        let userPic = UIImageView()
        self.view.addSubview(userPic)
        userPic.translatesAutoresizingMaskIntoConstraints = false
        userPic.tintColor = .gray
        userPic.layer.cornerRadius = 31
        userPic.image = UIImage(named: "userPic")
        return userPic
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .boldSystemFont(ofSize: 23)
        nameLabel.textColor = .ypWhite
        self.view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var usernameLabel: UILabel = {
        let usernameLabel = UILabel()
        usernameLabel.text = "@ekaterina_nov"
        usernameLabel.font = .systemFont(ofSize: 13)
        usernameLabel.textColor = .ypGray
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(usernameLabel)
        return usernameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Hello, World!"
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(descriptionLabel)
        return descriptionLabel
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton()
        logoutButton.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutButton.addTarget(self, action: #selector(self.logoutButtonDidTap), for: .touchUpInside)
        self.view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        return logoutButton
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .ypBlack
        presenter = ProfilePresenter(view: self)
        presenter?.viewDidLoad()
        setupUI()
        updateAvatar()
        
    }
    
    private func setupUI(){
        NSLayoutConstraint.activate([
            userPic.heightAnchor.constraint(equalToConstant: 70),
            userPic.widthAnchor.constraint(equalToConstant: 70),
            userPic.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 76),
            userPic.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: userPic.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            descriptionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            logoutButton.centerYAnchor.constraint(equalTo: userPic.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24)
        ])
    }

    
    @objc private func logoutButtonDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены что хотите выйти?", preferredStyle: .alert)
        let actionDismiss = UIAlertAction(title: "Нет", style: .default) {_ in
            alert.dismiss(animated: true)
        }
        let actionYes = UIAlertAction(title: "Да", style: .default) { _ in
            ProfileLogoutService.shared.logout()
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            window.rootViewController = SplashScreenViewController()
            window.makeKeyAndVisible()
        }
        alert.addAction(actionYes)
        alert.addAction(actionDismiss)
        self.present(alert, animated: true)
    }
}
