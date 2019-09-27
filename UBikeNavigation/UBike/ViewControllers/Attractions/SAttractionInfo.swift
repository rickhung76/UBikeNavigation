//
//  SAttractionInfo.swift
//  P6
//
//  Created by Frank Chen on 2019/9/25.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

struct SAttractionListInfo: Codable {
    let total: Int
    let data: [SAttractionInfo]
}

struct SAttractionInfo: Codable {
    let id: Int
    let name: String
    let introduction: String
    let open_time: String
    let address: String
    let nlat: CGFloat
    let elong: CGFloat
    let tel: String
    let official_site: String
    let remind: String
    let url: String
    let images: [SAttractionImageInfo]
}

struct SAttractionImageInfo: Codable {
    let src: String
    let subject: String
    let ext: String
}

/*
"id": 87,
"name": "臺北市鄉土教育中心_剝皮寮歷史街區",
"name_zh": null,
"open_status": 1,
"introduction": "穿梭在臺北市萬華區的老舊巷弄中，有一處名為「剝皮寮」的老街區，這裡依然延續著百餘年前清代街道的風貌，紅色的磚牆、拱型的騎樓、雕花的窗櫺，呈現典雅樸實之美。\r\n\r\n剝皮寮歷史街區位於龍山寺旁，康定路、廣州街及昆明街口，街區內保存有相當完整的清代街型、清代傳統店屋，其建築空間見證了艋舺市街的發展，擁有獨特之歷史文化和建築特色。\r\n\r\n「臺北市鄉土教育中心」以融入式教育與文化之理念，使其作為推展鄉土教育之園地，將學校教育和社區文化相結合，規劃不同主題展覽，及剝皮寮相關歷史特展，並辦理各項教育活動，以達寓教於樂的功能。\r\n\r\n\r\n\r\n\r\n",
"open_time": "周二至周日9：00-17：00，周一及國定假日休館",
"zipcode": "108",
"distric": "萬華區",
"address": "108 臺北市萬華區廣州街101號",
"tel": "+886-2-23361704",
"fax": "",
"email": "hcec.tp@msa.hinet.net",
"months": "01,07,02,08,03,09,04,10,05,11,06,12",
"nlat": 25.03666,
"elong": 121.50327,
"official_site": "http://59.120.8.196/enable2007/",
"facebook": "",
"ticket": "免費入場",
"remind": "備註事項:免費，團體採預約制，個人可自由參觀，採總量管制入場。",
"staytime": "",
"modified": "2019-09-20 10:46:29 +08:00",
"url": "https://www.travel.taipei/zh-tw/attraction/details/87",
"category": [
*/
