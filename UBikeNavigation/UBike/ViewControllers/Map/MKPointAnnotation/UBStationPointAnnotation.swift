//
//  UBStationPointAnnotation.swift
//  P6
//
//  Created by 黃柏叡 on 2019/9/26.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation
import MapKit

public class UBStationPointAnnotation: FCMKPointAnnotation {
    var name: String
    var availableSpaces: Int
    var emptySpaces: Int
    
    init(name: String,
         availableSpaces: Int,
         emptySpaces: Int,
         coordinate: CLLocationCoordinate2D) {
        
        self.name = name
        self.availableSpaces = availableSpaces
        self.emptySpaces = emptySpaces
        super.init()
        self.coordinate = coordinate
        self.title = name
        self.subtitle = "可借：\(availableSpaces)  空位：\(emptySpaces)"
        self.image = UIImage(named: "FCMapViewController_location")
    }
}
