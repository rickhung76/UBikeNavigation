//
//  WJTabViewController.swift
//  P6
//
//  Created by 黃柏叡 on 2019/9/24.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class SUBikeTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let homeVC = SUBikeRootNavigationController(rootViewController: FCMapViewController())
        homeVC.tabBarItem = UITabBarItem(title: "UBike", image: UIImage(named: "sbike"), selectedImage: UIImage(named: "sbike"))

        
        viewControllers = [homeVC]
    }

}
