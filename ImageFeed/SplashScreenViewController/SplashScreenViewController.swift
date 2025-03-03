//
//  SplashScreenViewController.swift
//  ImageFeed
//
//  Created by Olya on 18.11.2024.
//

import UIKit

class SplashScreenViewController: UIViewController, AuthViewControllerDelegate {
    
    
    // MARK: - Public Properties
    
    // MARK: - Private Properties
    
    private let storage = OAuth2TokenStorage.shared
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("splashview appeared")
        if let token = storage.token {
            fetchProfile(token)
        } else {
            switchToAuthViewController()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    
    
    // MARK: - Private Methods
    
    private func setupUI() {
        let splashImage = UIImage(named: "splash_screen_logo")
        let logoImage = UIImageView(image: splashImage)
        
        view.addSubview(logoImage)
        view.backgroundColor = UIColor.ypBlack
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImage.widthAnchor.constraint(equalToConstant: 75),
            logoImage.heightAnchor.constraint(equalToConstant: 77.68),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarController")
        window.rootViewController = tabBarController
    }
    
    private func switchToAuthViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {return}
        authViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) { result in
                    switch result {
                    case .success(let avatarURL):
                        print("Avatar URL fetched successfully: \(avatarURL)")
                    case .failure(let error):
                        print("Failed to fetch avatar URL: \(error)")
                    }
                }
                self.switchToTabBarController()
            case .failure:
                print("Failed to fetch profile")
                let alert = UIAlertController(
                    title: "Error", message: "Failed to load profile. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
    
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true)
        
        guard let token = storage.token else { return }
        fetchProfile(token)
    }
}
