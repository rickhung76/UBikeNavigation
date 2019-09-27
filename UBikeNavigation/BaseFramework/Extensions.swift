//
//  Extensions.swift
//  UBikeNavigation
//
//  Created by 黃柏叡 on 2019/9/27.
//  Copyright © 2019 黃柏叡. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension UIView {
    
    static var className: String {
        return String(describing: self)
    }
    
    var allSubviews: [UIView] {
        return self.subviews.reduce([UIView]()) { $0 + [$1] + $1.allSubviews }
    }
    
    var grabbedImage:UIImage? {
        get {
            UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
            layer.render(in: UIGraphicsGetCurrentContext()!)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img
        }
    }
    
    func setBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    func setRadiusBorder(width: CGFloat = 0, color: UIColor = .gray, radius: CGFloat = 0) {
        self.setBorder(width: width, color: color)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius != 0 ? radius : self.frame.height / 2
    }
}


extension UISegmentedControl {
    func replaceSegments(segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}
