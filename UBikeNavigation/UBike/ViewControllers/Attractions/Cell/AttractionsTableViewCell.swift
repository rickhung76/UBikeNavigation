//
//  AttractionsTableViewCell.swift
//  P6
//
//  Created by Ike Ho on 2019/9/25.
//  Copyright © 2019 Frank Chen. All rights reserved.
//

import UIKit
//import Kingfisher

class VerticalTopAlignLabel: UILabel {

    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }

        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font as Any])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height

        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }

        super.drawText(in: newRect)
    }

}

class AttractionsTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var openTime: UILabel!
    @IBOutlet weak var address: VerticalTopAlignLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initWith(info: SAttractionInfo) {
        self.icon.kf.setImage(with: URL(string: info.images.first?.src ?? ""), placeholder: UIImage(named: "SImage"), options: [.cacheOriginalImage])
        self.name.text = info.name
        self.openTime.text = info.open_time
        self.address.text = info.address
    }
}
