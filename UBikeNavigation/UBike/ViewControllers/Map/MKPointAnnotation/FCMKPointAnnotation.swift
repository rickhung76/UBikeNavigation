//
//  FCMKPointAnnotation.swift
//  TaiwanPlay
//
//  Created by Frost on 2016/6/1.
//  Copyright © 2016年 Frost Chen. All rights reserved.
//

import UIKit
import MapKit

public class FCMKPointAnnotation: MKPointAnnotation {
    var pointTitle:String? = nil
    var subTitle:String? = nil
    var image:UIImage? = nil
    
    public init(image:UIImage?) {
        self.image = image
        super.init()
    }
    
    public override init() {
        super.init()
    }
}
