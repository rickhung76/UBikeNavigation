//
//  ResponseModel + NewTaipeiUBike.swift
//  UBikeNow
//
//  Created by William_Kuo on 2019/9/1.
//  Copyright © 2019 William_Kuo. All rights reserved.
//

import Foundation

struct NewTaipeiUBikeResponseModel: Decodable {
    var success: Bool
    let result: NewTaipeiUBikeResult
}

struct NewTaipeiUBikeResult: Decodable {
    var records: [UBikeStation]
}
