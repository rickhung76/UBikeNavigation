//
//  SWeatherInfo.swift
//  P6
//
//  Created by Frank Chen on 2019/9/24.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

struct SWeatherInfo: Codable {
    let desc: String
    let temperature: Int
    let felt_air_temp: Int
    let humidity: Int
    let rainfall: CGFloat
    let sunrise: String
    let sunset: String
    let at: String
}


/*
 "img": "01@2x.png",
 "desc": "晴",
 "temperature": 31,
 "felt_air_temp": 35,
 "humidity": 71,
 "rainfall": 4,
 "sunrise": "05:35",
 "sunset": "18:08",
 "at": "2018-09-05 16:35:01",
*/
