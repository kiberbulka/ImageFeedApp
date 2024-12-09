//
//  URLSession.swift
//  ImageFeed
//
//  Created by Olya on 17.11.2024.
//

import Foundation

enum NetworkError: Error {  // 1
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    func objectTask<T: Decodable>(
            for request: URLRequest,
            completion: @escaping (Result<T, Error>) -> Void
        ) -> URLSessionTask {
            let decoder = JSONDecoder()

            let task = self.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("[objectTask]: NetworkError - \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }

                guard let data = data else {

                    print("[objectTask]: NetworkError - No data received.")
                    completion(.failure(NetworkError.urlSessionError))
                    return
                }

                do {

                    let decodedObject = try decoder.decode(T.self, from: data)
                    completion(.success(decodedObject))
                } catch {

                    let dataString = String(data: data, encoding: .utf8) ?? "Не удалось преобразовать данные в строку."
                    print("[objectTask]: DecodingError - \(error.localizedDescription), Данные: \(dataString)")
                    completion(.failure(error))
                }
            }

            task.resume()  
            return task
        }
}
