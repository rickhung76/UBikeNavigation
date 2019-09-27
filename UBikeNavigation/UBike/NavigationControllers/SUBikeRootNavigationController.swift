//
//  WJRootNavigationController.swift
//  P6
//
//  Created by 黃柏叡 on 2019/9/24.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class SUBikeRootNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barTintColor = UIColor(rgb: 0x007AFF).withAlphaComponent(1)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationBar.titleTextAttributes = textAttributes
        navigationBar.isTranslucent = false
        navigationBar.tintColor = UIColor.white
        
        navigationBar.setBackgroundImage(UIImage(named: "bg_01"), for: .default)
        navigationBar.setValue(true, forKey: "hidesShadow")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
}
