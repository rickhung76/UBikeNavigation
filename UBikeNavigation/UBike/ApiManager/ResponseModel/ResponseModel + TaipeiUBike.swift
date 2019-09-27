//
//  ResponseModel + TaipeiUBike.swift
//  UBikeNow
//
//  Created by William_Kuo on 2019/9/1.
//  Copyright © 2019 William_Kuo. All rights reserved.
//

import Foundation

struct TaipeiUBikeResponseModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case success = "retCode"
        case result =  "retVal"
    }
    
    var success: Bool
    let result: TaipeiUBikeResult
    
    init(from decoder: Decoder) throws {
        
        do {
            let vals = try decoder.container(keyedBy: CodingKeys.self)
            
            let successIntVal = try vals.decode(Int.self, forKey: .success)
            self.success = successIntVal == 1
            
            let resultDict = try vals.decode(Dictionary<String, UBikeStation>.self, forKey: .result)
            let bikes = Array(resultDict.values)
            let result = TaipeiUBikeResult.init(records: bikes)
            self.result = result
        } catch {
            print("Error -> \(error)")
            throw(error)
        }
    }
}

struct TaipeiUBikeResult: Decodable {
    var records: [UBikeStation]
}
