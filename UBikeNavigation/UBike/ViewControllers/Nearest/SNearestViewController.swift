//
//  NearestViewController.swift
//  P6
//
//  Created by Frank Chen on 2019/9/25.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
import CoreLocation

protocol SNearestViewControllerDelegate: class {
    func selected(station: UBikeStation)
}

class SNearestViewController: FCBaseViewController {
    var ubikeStations: [UBikeStation] = []
    weak var delegate: SNearestViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    init(ubikeStations: [UBikeStation]) {
        super.init()
        self.ubikeStations = ubikeStations
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "最近的Ubike地點"
        self.initTableView()

        // Do any additional setup after loading the view.
    }

    private func initTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: SNearestCell.className, bundle: nil), forCellReuseIdentifier: SNearestCell.className)
    }
}

extension SNearestViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ubikeStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = self.ubikeStations[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SNearestCell.className, for: indexPath) as! SNearestCell
        
        cell.initWith(index: (indexPath.row + 1), info: info)
        
        return cell
    }
}

extension SNearestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.ubikeStations[indexPath.row]
        self.delegate?.selected(station: info)
        self.dismiss()
    }
}

