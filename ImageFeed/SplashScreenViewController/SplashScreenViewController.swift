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
    
    private let storage = OAuth2TokenStorage()
    private let showAuthenticationScreenSegueIdentifier = "ShowAutentificationScreen"
//    private let oauth2Service = OAuth2Service.shared
//    private let profileService = ProfileService()
    private enum SplashViewControllerConstants {
        static let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    }
    
    
    
    
    // MARK: - Initializers
    
    // MARK: - Overrides Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("splashview appeared")
        if let token = storage.token {
            fetchProfile(token)
        } else {
            performSegue(withIdentifier: SplashViewControllerConstants.showAuthenticationScreenSegueIdentifier, sender: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SplashViewControllerConstants.showAuthenticationScreenSegueIdentifier {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(SplashViewControllerConstants.showAuthenticationScreenSegueIdentifier)")
                return
            }
            
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: - Public Methods
    
//    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
//        dismiss(animated: true) { [weak self] in
//            guard let self = self else { return }
//            self.fetchOAuthToken(code)
//        }
//    }
    
    // MARK: - Private Methods
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarController")
        window.rootViewController = tabBarController
    }
    
//    private func fetchOAuthToken(_ code: String) {
//        oauth2Service.fetchOAuthToken(code) { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success:
//                self.switchToTabBarController()
//            case .failure(let error):
//                print("fetch token error \(error)")
//            }
//        }
//    }
    
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
