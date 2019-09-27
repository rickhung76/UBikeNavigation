//
//  TableViewLoadingCell.swift
//  P6
//
//  Created by Ike Ho on 2019/9/25.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class TableViewLoadingCell: UITableViewCell {
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func startLoading() {
        self.indicatorView.startAnimating()
    }
}
