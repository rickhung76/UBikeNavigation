//
//  Utils.swift
//  P6
//
//  Created by 黃柏叡 on 2019/9/16.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import Foundation
import UIKit


class Util {
    static func alertMessage(title: String?, message: String?,
                             textColor: UIColor? = nil,
                             leftButtonTitle: String? = nil,
                             centerButtonTitle: String,
                             rightButtonTitle: String? = nil,
                             messageAligment: NSTextAlignment = .center,
                             closure: ((String)->())? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if leftButtonTitle != nil {
            let leftButton = UIAlertAction(title: leftButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
                closure?(leftButtonTitle!)
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(leftButton)
        }
        
        let centerButton = UIAlertAction(title: centerButtonTitle, style: .default , handler: { (action: UIAlertAction!) in
            closure?(centerButtonTitle)
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(centerButton)
        
        if let rightButtonTitle = rightButtonTitle
        {
            let rightButton = UIAlertAction(title: rightButtonTitle, style: .default, handler: { (action: UIAlertAction!) in
                closure?(rightButtonTitle)
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(rightButton)
        }
        
        // message text alignment left
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = messageAligment
        
        // text color
        if textColor != nil {
            if title != nil {
                let titleString = NSAttributedString(string: title!, attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17),
                    NSAttributedString.Key.foregroundColor : textColor!])
                alert.setValue(titleString, forKey: "attributedTitle")
            }
            
            if message != nil {
                let messageString = NSAttributedString(string: message!, attributes: [
                    NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13),
                    NSAttributedString.Key.foregroundColor : textColor!,
                    NSAttributedString.Key.paragraphStyle: paragraphStyle])
                alert.setValue(messageString, forKey: "attributedMessage")
            }
        }
        
        if let topViewController = self.getTopViewController() {
            DispatchQueue.main.async {
                topViewController.present(alert, animated: false, completion: nil)
                if textColor != nil {
                    alert.view.tintColor = textColor
                }
            }
        }
    }
    
    static func getTopViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            return rootViewController
        }
        
        if let navigationController = controller as? UINavigationController {
            return getTopViewController(controller: navigationController.visibleViewController)
        }
        
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return getTopViewController(controller: selected)
            }
        }
        
        if let presented = controller?.presentedViewController {
            return getTopViewController(controller: presented)
        }
        
        return controller
    }
    
    static func getTopVC(exceptAlertVC: Bool = true) -> UIViewController? {
        var topVC: UIViewController?
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            if let navigationController = rootViewController as? UINavigationController {
                if exceptAlertVC {
                    for vc in navigationController.viewControllers.reversed() {
                        if vc as? UIAlertController == nil {
                            topVC = vc
                            break
                        }
                    }
                } else {
                    topVC = navigationController.viewControllers.reversed().first
                }
                //            } else if let tabController = rootViewController as? UITabBarController {
                //                if let selected = tabController.selectedViewController, selected != (exceptVC as? UIViewController) {
                //                    topVC = selected
                //                }
            } else {
                topVC = rootViewController
            }
        }
        
        return topVC
    }
    
    static func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        if animated {
            UIView.transition(with: window, duration: 0.6, options: .transitionCrossDissolve, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                window.rootViewController = rootViewController
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
}

