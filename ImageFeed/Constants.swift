//
//  Constants.swift
//  ImageFeed
//
//  Created by Olya on 14.11.2024.
//

import Foundation
enum Constants{
    static let accessKey = "Ode9gWMaDkyQPjanDRZvCWx7QMVO6SJH5zhORhREYC8"
    static let secretKey = "F-favgoXnilpiebzXQ5y6cRrnAZuUaczbnbq_2O5hyk"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = {
        guard let url = URL(string: "https://api.unsplash.com") else {
            fatalError("Ошибка: невозможно создать URL из строки")
        }
        return url
    }()
    static let photos: String = "photos"
    static let perPage: String = "10"
}
