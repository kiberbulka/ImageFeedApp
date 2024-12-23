//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Olya on 17.11.2024.
//

import Foundation

final class OAuth2Service {
    
    enum AuthServiceError: Error {
        case invalidRequest
    }
    
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
    private var task: URLSessionTask?
    private var lastCode: String?
    private var storage = OAuth2TokenStorage()
    
    
    // MARK: - Private Initializers
    
    init (){}
    
    
    // MARK: - Public Methods
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, any Error>) -> Void) {
        assert(Thread.isMainThread)
        if task != nil {
            if lastCode != code {
                task?.cancel()
            } else {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        } else {
            if lastCode == code {
                completion(.failure(AuthServiceError.invalidRequest))
                return
            }
        }
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let error = error {
                    print("[fetchOAuthToken]: Network - \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    print("[fetchOAuthToken]: InvalidResponse - No data received.")
                    completion(.failure(AuthServiceError.invalidRequest))
                    return
                }
                do {
                    let tokenResponse = try self.decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.storage.token = tokenResponse.accessToken
                    print("Received access token: \(tokenResponse.accessToken)")
                    completion(.success(tokenResponse.accessToken))
                } catch {
                    print("[fetchOAuthToken]: Ошибка декодирования - \(error.localizedDescription), Данные: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
                
                self.task = nil
                self.lastCode = nil
            }
        }
        task?.resume()
    }
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard let baseURL = URL(string: "https://unsplash.com") else {
            assertionFailure("Failed to create URL")
            return nil
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

