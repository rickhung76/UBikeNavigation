//
//  DataLoader.swift
//  UBikeNow
//
//  Created by William_Kuo on 2019/9/1.
//  Copyright © 2019 William_Kuo. All rights reserved.
//

import Foundation

enum APIError: Error {
    case invalideURL
    case noResponseData
    case noDataModel
    case wrongFormat(_ error: Error?)
}

final class DataLoader {
    public func request<Model: Decodable>(type: Model.Type, _ endpoint: Endpoint, httpBody: Data? = nil, then handler: @escaping(Result<Model, APIError>) -> Void) {
        
        guard let url = endpoint.url else {
            return handler(.failure(APIError.invalideURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.httpBody = httpBody
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return handler(.failure(.noDataModel))
            }
            
            do {
                let model = try JSONDecoder().decode(Model.self, from: data)
                handler(.success(model))
            } catch {
                handler(.failure(APIError.wrongFormat(error)))
            }
        }
        
        task.resume()
    }
}
