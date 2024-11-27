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
    static let defaultBaseURL = URL(string: "https://api.unsplash.com") ?? URL(string: "")
}
