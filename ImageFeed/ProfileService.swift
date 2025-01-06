//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Olya on 04.12.2024.
//

import Foundation
import UIKit

struct ProfileResult: Codable {
    let username: String
    let firstName: String?
    let lastName: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case username
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
    }
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(from profileResult: ProfileResult) {
        self.username = profileResult.username
        let fullName = [profileResult.firstName, profileResult.lastName].compactMap { $0 }.joined(separator: " ")
        self.name = fullName.isEmpty ? profileResult.username : fullName
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
}

enum AuthServiceError: Error {
    case invalidRequest
}

final class ProfileService {
    
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastToken: String?
    private(set) var profile: Profile?
    
    private init() {
        
    }
    private func makeProfileRequest(token: String) -> URLRequest? {
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            assertionFailure("Failed to create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        if lastToken == token && task != nil {return}
        task?.cancel()
        lastToken = token
        
        guard let request = makeProfileRequest(token: token) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let profileResult):
                    let profile = Profile(from: profileResult)
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    print("[fetchProfile]: \(error.localizedDescription), Request: \(request.url?.absoluteString ?? "")")
                    completion(.failure(error))
                }
                
                self.task = nil
                self.lastToken = nil
            }
        }
        task?.resume()
    }
}
