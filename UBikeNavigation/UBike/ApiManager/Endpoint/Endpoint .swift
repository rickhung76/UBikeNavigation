//
//  Endpoint .swift
//  UBikeNow
//
//  Created by William_Kuo on 2019/9/1.
//  Copyright © 2019 William_Kuo. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case post = "POST"
    case get = "GET"
    case delete = "DELETE"
    case put = "PUT"
}

class Endpoint {
    let host: String
    let path: String
    let queryItems: [URLQueryItem]
    let httpMethod: HttpMethod
    
    init(host: String, path: String, queryItems: [URLQueryItem] = [], httpMethod: HttpMethod = .get) {
        self.host = host
        self.path = path
        self.queryItems = queryItems
        self.httpMethod = httpMethod
    }
}

extension Endpoint {
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = queryItems
        
        return components.url
    }
}
