//
//  APIService.swift
//  UBikeNow
//
//  Created by William_Kuo on 2019/9/1.
//  Copyright © 2019 William_Kuo. All rights reserved.
//

import Foundation

protocol APIServiceProtocol {
    func fetchNewTaipeiUBikeStations(then handler: @escaping (Result<[UBikeStation], APIError>) -> Void)
    func fetchTaipeiUBikeStations(then handler: @escaping (Result<[UBikeStation], APIError>) -> Void)
}

final class APIService {
    static let shared = APIService()
    private init() {}
    
    let dataLoader = DataLoader()
}

