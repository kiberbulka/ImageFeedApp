//
//  PhotoServices.swift
//  ImageFeed
//
//  Created by Olya on 06.01.2025.
//

import Foundation
struct PhotoResult: Decodable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let urls: UrlsResult
    let likedByUser: Bool
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case urls
        case likedByUser = "liked_by_user"
        case description
    }
}

struct UrlsResult: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let aspectRatio: CGFloat
    let isLiked: Bool
}

extension Photo {
    static func from(photoResult: PhotoResult) -> Photo {
        let dateFormatter = ISO8601DateFormatter()
        let date = photoResult.createdAt.flatMap { dateFormatter.date(from: $0)}
        let aspectRatio = CGFloat(photoResult.width) / CGFloat(photoResult.height)
        
        return Photo(id: photoResult.id,
                     size: CGSize(width: photoResult.width, height: photoResult.height),
                     createdAt: date,
                     welcomeDescription: photoResult.description ?? "No description",
                     thumbImageURL: photoResult.urls.thumb,
                     largeImageURL: photoResult.urls.full,
                     aspectRatio: aspectRatio,
                     isLiked: photoResult.likedByUser
        )
    }
}
