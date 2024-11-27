//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Olya on 17.11.2024.
//

import Foundation

final class OAuth2Service {
    
    // MARK: - Public Properties
    
    static let shared = OAuth2Service()
    var authToken: String? {
        get {
            OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    
    // MARK: - Private Properties
    
    private let urlSession = URLSession.shared
    private let decoder = JSONDecoder()
    
    
    // MARK: - Initializers
    
    private init (){}
    
    
    // MARK: - Public Methods
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, any Error>) -> Void) {
        
        let request = makeOAuthTokenRequest(code: code)
        
        let task = urlSession.data(for: request) { [weak self] result in
            
            guard let self else { preconditionFailure("self is unavalible") }
            
            switch result {
            case .success(let data):
                
                do {
                    let OAuthTokenResponseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    print(OAuthTokenResponseBody)
                    print(OAuthTokenResponseBody.accessToken)
                    self.authToken = OAuthTokenResponseBody.accessToken
                    completion(.success(OAuthTokenResponseBody.accessToken))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
        task.resume()
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            preconditionFailure("Invalid sheme or host name")
        }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL                           
        ) else {
            preconditionFailure("Cannot make url")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
    
    
}

