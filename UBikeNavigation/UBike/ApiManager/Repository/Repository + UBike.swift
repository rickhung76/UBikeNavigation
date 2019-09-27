//
//  Repository + UBike.swift
//  UBikeNow
//
//  Created by William_Kuo on 2019/9/1.
//  Copyright © 2019 William_Kuo. All rights reserved.
//

import Foundation

final class UBikeRepository {
    static let shared = UBikeRepository()
    private init() {}
}

extension UBikeRepository {
    func fetchAllUBikeStations(than handler: @escaping((Result<[UBikeStation], APIError>) -> Void)) {
        
        let group = DispatchGroup()
        var allUBikeStations: [UBikeStation] = []
        
        group.enter()
        APIService.shared.fetchTaipeiUBikeStations { (result) in
            switch result {
            case .success(let stations):
                allUBikeStations.append(contentsOf: stations)
                group.leave()
            case .failure(let error):
                print("[API Error] fetch taipei ubike staions, \(error)")
                group.leave()
            }
        }
        
        group.enter()
        APIService.shared.fetchNewTaipeiUBikeStations { (result) in
            switch result {
            case .success(let stations):
                allUBikeStations.append(contentsOf: stations)
                group.leave()
            case .failure(let error):
                print("[API Error] fetch taipei ubike staions, \(error)")
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if allUBikeStations.isEmpty {
                handler(.failure(APIError.noResponseData))
            } else {
                handler(.success(allUBikeStations))
            }
        }
        
    }
}
