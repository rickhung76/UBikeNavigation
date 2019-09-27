//
//  APIService + UBikeStation.swift
//  UBikeNow
//
//  Created by William_Kuo on 2019/9/1.
//  Copyright © 2019 William_Kuo. All rights reserved.
//

import Foundation

extension APIService: APIServiceProtocol {
    
    func fetchNewTaipeiUBikeStations(then handler: @escaping (Result<[UBikeStation], APIError>) -> Void) {
        dataLoader.request(type: NewTaipeiUBikeResponseModel.self, Endpoint.newTaipeiUBikes()) { (result) in
            switch result {
            case .success(let data):
                handler(.success(data.result.records))
            case .failure(let error):
                print("error -> \(error)")
                handler(.failure(error))
            }
        }
    }
    
    func fetchTaipeiUBikeStations(then handler: @escaping (Result<[UBikeStation], APIError>) -> Void) {
        dataLoader.request(type: TaipeiUBikeResponseModel.self, Endpoint.taipeiUBikes()) { (result) in
            switch result {
            case .success(let data):
                handler(.success(data.result.records))
            case .failure(let error):
                print("error -> \(error)")
                handler(.failure(error))
            }
        }
    }
}
