//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Olya on 11.01.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    static let shared = ProfileLogoutService()
    
    private init() {}
    
    func logout(){
        cleanCookies()
        clearStoredData()
        navigateToAuthVC()
    }
    
    private func cleanCookies(){
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
                
            }
        }
    }
    
    private func clearStoredData(){
        OAuth2TokenStorage.shared.token = nil
        ProfileService.shared.clearProfile()
        ProfileImageService.shared.clearProfileImage()
        ImagesListService.shared.clearPhotos()
        
    }
    
    private func navigateToAuthVC(){
        if let window = UIApplication.shared.windows.first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let authVC = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController {
                window.rootViewController = authVC
                window.makeKeyAndVisible()
            }
        }
    }
}
