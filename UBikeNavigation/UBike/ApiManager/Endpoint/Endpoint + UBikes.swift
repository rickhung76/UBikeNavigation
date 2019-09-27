//
//  Endpoint + UBikes.swift
//  UBikeNow
//
//  Created by William_Kuo on 2019/9/1.
//  Copyright © 2019 William_Kuo. All rights reserved.
//

import Foundation

extension Endpoint {
    static func newTaipeiUBikes() -> Endpoint {
        return Endpoint(host: NewTaipeiUBikeAPI.host,
                        path: NewTaipeiUBikeAPI.path,
                        httpMethod: .get)
    }
    
    static func taipeiUBikes() -> Endpoint {
        return Endpoint(host: TaipeiUBikeAPI.host,
                        path: TaipeiUBikeAPI.path,
                        httpMethod: .get)

    }
}
