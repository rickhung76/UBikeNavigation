//
//  PinView.swift
//  P6
//
//  Created by 黃柏叡 on 2019/9/24.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import MapKit

protocol PinView: MKAnnotationView {
    var nibName: String { get }
    func config(_ text: String?)
    func loadXib()
}

extension PinView {
    var nibName: String {return "PinView"}
    
    func loadXib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let xibView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(xibView)

        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

class PinAnnoView: MKAnnotationView, PinView {
    static let reusableId = "PinView"
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var label: PaddingLabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
        defer {
            self.config()
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        loadXib()
        defer {
            self.config()
        }
    }

    func config(_ text: String? = nil) {
        self.label.text = text
        self.label.sizeToFit()
        self.frame = self.label.frame
        self.bgView.setRadiusBorder()
    }
}

@available(iOS 11.0, *)
class PinMarkerView: MKMarkerAnnotationView, PinView {
    static let reusableId = "PinView"
    override var annotation: MKAnnotation? {
        willSet {
//          markerTintColor = artwork.markerTintColor
        }
      }
    
    func config(_ text: String? = nil) {
        glyphText = text
    }
}
