//
//  SNearestCell.swift
//  P6
//
//  Created by Frank Chen on 2019/9/25.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit

class SNearestCell: UITableViewCell {
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initWith(index: Int, info: UBikeStation) {
        self.indexLabel.text = "\(index)."
        self.titleLabel.text = info.chineseName
        self.countLabel.text = "剩餘UBike數: \(info.currentEmptySpacesCount)/\(info.totalSpacesCount)"
        self.addressLabel.text = "\(info.chineseAddress)"
        self.distanceLabel.text = "距離: \(self.metersToDistanceString(meters: info.distance ?? 0))"
    }
    
    private func metersToDistanceString(meters: Double) -> String {
        var unit = "m"
        
        if(meters > 1000){
            unit = "km"
            let Kilometers = meters/1000
            let KilometersString =  String(format:"%.2f", Kilometers)
            
            return "\(KilometersString) \(unit)"
        } else {
            let metersString =  String(format:"%.2f", meters)
            return "\(metersString) \(unit)"
        }
    }
}
