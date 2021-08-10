//
//  MyTableViewCell.swift
//  mvl-AirQuality
//
//  Created by 손대홍 on 2021/08/10.
//

import Foundation
import UIKit

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var content: String? {
        didSet {
            contentLabel.text = content
        }
    }
    
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
}
