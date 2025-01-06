//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Olya on 06.01.2025.
//

import Foundation
final class ImagesListService {
    private (set) var photos: [Photo] = []
       
    private var lastLoadedPage: Int?
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var currentPage: Int = 0
    private var isLoading: Bool = false
    private var photosPerPage: Int = 10
    private let urlSession = URLSession.shared
    static let shared = ImagesListService()
    private let storage = OAuth2TokenStorage()
    
       func fetchPhotosNextPage() {
           guard !isLoading else { return }
           isLoading = true
           
           let nextPage = currentPage + 1
           
           let baseUrl = Constants.defaultBaseURL
           
           guard var urlComponents = URLComponents(url: baseUrl.appendingPathComponent("/photos"), resolvingAgainstBaseURL: false) else {
               print("Failed to create URL components")
               isLoading = false
               return
           }
           urlComponents.queryItems = [
           URLQueryItem(name: "page", value: "\(nextPage)"),
           URLQueryItem(name: "per_page", value: "\(photosPerPage)")
           ]
           guard let url = urlComponents.url else {
               print("Failed to create URL")
               isLoading = false
               return
           }
           var request = URLRequest(url: url)
           if let token = storage.token {
               request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
           }
           
           let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
               guard let self = self else { return }
               self.isLoading = false
               
               if let error = error {
                   print("Failed to fetch photos: \(error)")
                   return
               }
               guard
                let data,
                let photoResults = try? JSONDecoder().decode([PhotoResult].self, from: data)
               else {
                   print("Faiked to decode photos")
                   return
               }
               
               let newPhotos = photoResults.map { Photo.from(photoResult: $0)}
               
               DispatchQueue.main.async {
                   self.photos.append(contentsOf: newPhotos)
                   self.currentPage = nextPage
                   NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
               }
           }
           task.resume()
       }
    
   
  

}
