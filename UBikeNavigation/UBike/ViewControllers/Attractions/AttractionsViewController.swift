//
//  AttractionsViewController.swift
//  P6
//
//  Created by Frank Chen on 2019/9/25.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class AttractionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var attractions: [SAttractionInfo] = []
    private var page: Int = 0
    private let maxPage: Int = 4
    
    lazy var refreshControl: FCAnimationRefreshControl = {
           let refreshControl = FCAnimationRefreshControl()
           refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControl.Event.valueChanged)
           return refreshControl
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestData()
        
        initUI()
        initTableView()
    }
    
    private func initUI() {
        self.title = "旅遊景點"
    }
    
    private func initTableView() {
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        tableView.tableFooterView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: CGFloat.leastNormalMagnitude))
        
        tableView.register(UINib(nibName: AttractionsTableViewCell.className, bundle: nil), forCellReuseIdentifier: AttractionsTableViewCell.className)
        tableView.register(UINib(nibName: TableViewLoadingCell.className, bundle: nil), forCellReuseIdentifier: TableViewLoadingCell.className)
        tableView.refreshControl = self.refreshControl
    }

    private func requestData() {
        DispatchQueue.main.async {
            FCLoadingDialog.shared.presentInWindow()
        }
        
        page += 1
        var urlComponents = URLComponents(string: "https://www.travel.taipei/open-api/zh-tw/Attractions/All")!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
        ]
  
        var request = URLRequest(url: urlComponents.url!)
       
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard data != nil && error == nil else {
                return
            }

            if let data = data, let attractionListInfo = try? JSONDecoder().decode(SAttractionListInfo.self, from: data) {
                self?.attractions.append(contentsOf: attractionListInfo.data)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            } else {

            }
            
            let apiResponse = String.init(data: data!, encoding: String.Encoding.utf8)!
            print(apiResponse)
            
            DispatchQueue.main.async {
                FCLoadingDialog.shared.dismissSelf()
            }
        }

        task.resume()
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.attractions.removeAll()
        self.page = 0
        DispatchQueue.main.async {
            refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
        
        self.requestData()
    }

}

extension AttractionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AttractionDetailViewController(info: self.attractions[indexPath.row])
        vc.presentFromViewController(ViewController: self)
    }
}

extension AttractionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if page != maxPage {
            return self.attractions.count + 1
        } else {
            return self.attractions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row < self.attractions.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: AttractionsTableViewCell.className, for: indexPath as IndexPath) as! AttractionsTableViewCell
            cell.initWith(info: self.attractions[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewLoadingCell.className, for: indexPath as IndexPath) as! TableViewLoadingCell
            cell.startLoading()
            return cell
        }
    }
}

extension AttractionsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 20.0
        let isReachingEnd = scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height - threshold)
        
        if(isReachingEnd && page < maxPage) {
            self.requestData()
        }
    }
}
