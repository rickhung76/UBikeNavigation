//
//  FCBaseViewController.swift
//  FCamera
//
//  Created by Frank Chen on 2018/11/27.
//  Copyright © 2018年 Frank Chen. All rights reserved.
//

import UIKit

public class FCBaseViewController: UIViewController {
    private var selectedTextField: UITextField?
    private var isScreenRaised = false
    var keyboardHeight: CGFloat = 0
    private var oriFrameOriginY: CGFloat = 0
    private var isKeyboardDidShow = false
    
    //for the bottom constraint of the first subview in scroll view if it's exist
    //to enable the scrolling of scroll view after keyboard raised
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var scrollContainerViewBottomConstraint: NSLayoutConstraint?
    var keyboardDidShowScrollYDistance: CGFloat = 0
    
    public init() {
        let className = NSStringFromClass(type(of: self))
        let bundle:Bundle = Bundle(for: NSClassFromString(className)!)
        let xibName = className.components(separatedBy: ".").last!
        super.init(nibName: xibName, bundle: bundle)
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initTextFields()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.initKeyboardNotifications()
        self.oriFrameOriginY = self.view.frame.origin.y
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            self.scrollContainerViewBottomConstraint?.constant = -window!.safeAreaInsets.bottom
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.closeKeyboard()
        NotificationCenter.default.removeObserver(self)
    }
    
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    public func presentFromViewController(ViewController VC:UIViewController, animated:Bool = true) {
        if let navigationController =  VC.navigationController {
            navigationController.pushViewController(self, animated: animated) }
        else {
            VC.present(self, animated: true, completion: nil)
        }
    }
    
    public func dismiss(toRootVC: Bool = false) {
        if(self.navigationController != nil) {
            if toRootVC {
                _ = self.navigationController?.popToRootViewController(animated: true)
            } else {
                _ = self.navigationController?.popViewController(animated: true);
            }
        } else {
            self.dismiss(animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    private func initKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func initTextFields() {
        let textFields:[UITextField] = view.allSubviews.filter{$0 is UITextField} as! [UITextField]
        
        for textField in textFields {
            textField.delegate = self
        }
    }
    
    private func closeKeyboard() {
        let textFields:[UITextField] = view.allSubviews.filter{$0 is UITextField} as! [UITextField]
        
        for textField in textFields {
            textField.resignFirstResponder()
        }
    }
    
    private func raiseScreen() {
        if let selectedTextField = selectedTextField {
            let distance: CGFloat = 100
            let locationY = (selectedTextField.superview == nil) ? selectedTextField.frame.origin.y: selectedTextField.superview!.convert(selectedTextField.frame, to: self.view).origin.y 
            let threshold = self.view.frame.size.height - keyboardHeight
            
            if(locationY > (threshold - distance)) {
                let moveDistance: CGFloat = (threshold - distance) - locationY
                self.isScreenRaised = true
                UIView.animate(withDuration: 0.4) {
                    self.view.frame = CGRect(x: 0, y: moveDistance, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }
            }
        }
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        self.isKeyboardDidShow = true
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardSize:CGSize = keyboardFrame.size
        self.keyboardHeight = keyboardSize.height
        //print("keyboardSize.height: \(keyboardSize.height)")
        
        if let containerViewBottomConstraint = self.scrollContainerViewBottomConstraint {
            let window = UIApplication.shared.keyWindow
            if #available(iOS 11.0, *) {
                containerViewBottomConstraint.constant = self.keyboardHeight - window!.safeAreaInsets.bottom
            } else {
                containerViewBottomConstraint.constant = self.keyboardHeight
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            self.raiseScreen()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if let containerViewBottomConstraint = self.scrollContainerViewBottomConstraint {
            let window = UIApplication.shared.keyWindow
            if #available(iOS 11.0, *) {
                containerViewBottomConstraint.constant = -window!.safeAreaInsets.bottom
            } else {
                containerViewBottomConstraint.constant = 0
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        } else {
            if(self.isScreenRaised == true) {
                UIView.animate(withDuration: 0.4, animations: {
                    UIView.animate(withDuration: 0.4) {
                        self.view.frame = CGRect(x: 0, y: self.oriFrameOriginY, width: self.view.frame.size.width, height: self.view.frame.size.height)
                    }
                }) { (isCompleted) in
                    self.isScreenRaised = false
                }
            }
        }
        
        isKeyboardDidShow = false
    }
}

extension FCBaseViewController: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
        
        if (scrollContainerViewBottomConstraint != nil) {
            let point = CGPoint(x: 0, y: textField.frame.origin.y + self.keyboardDidShowScrollYDistance)
            self.scrollView?.setContentOffset(point, animated: true)
        } else if(self.isKeyboardDidShow == true) {
             self.raiseScreen()
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        selectedTextField = nil
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension FCBaseViewController {
    public func setNavigationEmptyBack() {
        let btnBack = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let btnBackBarButtonItem = UIBarButtonItem.init(customView: btnBack)
        btnBackBarButtonItem.style = .plain
        btnBackBarButtonItem.title = ""
        self.navigationItem.leftBarButtonItem = btnBackBarButtonItem
    }
    
    public func setNavigationBack(_ action: Selector?) {
        let btnBack = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        btnBack.setImage(UIImage.init(named: "btnGoback"), for: .normal)
        btnBack.setImage(UIImage.init(named: "btnGoback"), for: .highlighted)
        btnBack.imageView?.contentMode = .scaleAspectFit
        btnBack.contentVerticalAlignment = .fill
        btnBack.contentHorizontalAlignment = .left
        btnBack.addTarget(self, action: action ?? #selector(btnBackPressed(sender:)), for: .touchUpInside)
        
        let btnBackBarButtonItem = UIBarButtonItem.init(customView: btnBack)
        btnBackBarButtonItem.style = .plain
        btnBackBarButtonItem.title = ""
        self.navigationItem.leftBarButtonItem = btnBackBarButtonItem
    }
    
    @objc func btnBackPressed(sender: Any?) {
        self.dismiss()
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .lightContent
    }
}
