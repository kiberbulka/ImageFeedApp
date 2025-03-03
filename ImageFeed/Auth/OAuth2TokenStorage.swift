//
//  OAuth2Token.swift
//  ImageFeed
//
//  Created by Olya on 17.11.2024.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: "AuthToken")
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: "AuthToken")
            } else {
                KeychainWrapper.standard.remove(forKey: "AuthToken")
            }
        }
    }
    
    private init() {}
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case token
    }
}
