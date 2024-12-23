//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Olya on 14.11.2024.
//

import UIKit
import WebKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
//    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
    func didAuthenticate(_ vc: AuthViewController)
}

final class AuthViewController: UIViewController {
    private let ShowWebViewSegueIdentifier = "ShowWebView"
    
    weak var delegate: AuthViewControllerDelegate?
    private let oauth2Service = OAuth2Service()
    private var progressElement = UIBlockingProgressHUD()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(ShowWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
        UIBlockingProgressHUD.show()
        
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            
            switch result {
            case .success(let token):
//                ProfileService.shared.fetchProfile(token) { profileResult in
//                    DispatchQueue.main.async {
//                        switch profileResult {
//                        case .success:
//                            self.delegate?.authViewController(self, didAuthenticateWithCode: code)
//                        case .failure(let error):
//                            print("Failed to fetch profile: \(error)")
//                            self.showAlertError(message: "Не удалось получить профиль прльзователя")
//                        }
//                    }
//                }
                
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("Failed to fetch OAuth2 token: \(error.localizedDescription)")
                showAlertError(message: "Не удалось получить профиль пользователя")
            }
            
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Что-то пошло не так", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
