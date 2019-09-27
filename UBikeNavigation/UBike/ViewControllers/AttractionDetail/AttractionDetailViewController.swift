//
//  AttractionDetailViewController.swift
//  P6
//
//  Created by Ike Ho on 2019/9/25.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import MapKit
//import FSPagerView

class AttractionDetailViewController: FCBaseViewController {
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.className)
        }
    }
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var telLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var remindLabel: UILabel!
    
    private var info: SAttractionInfo!
    private var hasImage: Bool {
        return self.info.images.count != 0
    }

    convenience init(info: SAttractionInfo) {
        self.init()
        self.info = info
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBack(nil)
        
        initUI()
        initPagerView()
    }
    
    func initUI() {
        self.title = "地點詳情"
        
        self.nameLabel.text = self.info.name
        self.openLabel.text = "營業時間：\(self.info.open_time)"
        self.telLabel.text = self.info.tel
        
        let underlineAttriString = NSMutableAttributedString(string: self.info.address)
        let range = (self.info.address as NSString).range(of: self.info.address)
        underlineAttriString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        underlineAttriString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        let combination = NSMutableAttributedString()
        combination.append(NSMutableAttributedString(string: "地址："))
        combination.append(underlineAttriString)
        self.addressLabel.attributedText = combination
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(tapLabel(gesture:)))
        self.addressLabel.isUserInteractionEnabled = true
        self.addressLabel.addGestureRecognizer(tapGes)
        
        self.introductionLabel.text = self.info.introduction.trim()
        self.remindLabel.text = self.info.remind.trim()
        
        self.introductionLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        self.introductionLabel.FCSetToDialogViewLayer(cornerRadius: 6)
        self.introductionLabel.layer.shadowOpacity = 0.0
    }
    
    func initPagerView() {
        if hasImage {
            self.pagerView.automaticSlidingInterval = 3.0
            self.pagerView.isInfinite = true
        }
        
        self.pageControl.numberOfPages = self.info.images.count
        self.pageControl.currentPage = 0
        self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let location = CLLocation(latitude: CLLocationDegrees(self.info.nlat), longitude: CLLocationDegrees(self.info.elong))
        let dialog = FCMapDialog(title: "地圖", location: location, locationTitle: self.info.name, buttonTitle: "確定")
        dialog.titleTextColor = .white
        dialog.titleViewColor = UIColor(rgb: 0x007AFF).withAlphaComponent(0.6)
        dialog.presentInView(parentViewController: self)
    }
}

extension AttractionDetailViewController: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.hasImage ? self.info.images.count : 1
    }
        
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.className, at: index)
        if hasImage {
            cell.imageView?.kf.setImage(with: URL(string: info.images[index].src), placeholder: UIImage(named: "SImage"), options: [.cacheOriginalImage])
        } else {
            cell.imageView?.image = UIImage(named: "SImage")
            cell.imageView?.contentMode = .scaleAspectFit
        }
        return cell
    }
}

extension AttractionDetailViewController: FSPagerViewDelegate {
    func pagerView(_ pagerView: FSPagerView, shouldHighlightItemAt index: Int) -> Bool{
        return false
    }
    
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        self.pageControl.currentPage = targetIndex
    }
    
    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
        self.pageControl.currentPage = pagerView.currentIndex
    }
}
