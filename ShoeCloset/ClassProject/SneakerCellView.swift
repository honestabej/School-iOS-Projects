//
//  sneakerCell.swift
//  ClassProject
//
//  Created by Abe Johnson on 4/6/21.
//

import Foundation
import UIKit

class SneakerCellView: UITableViewCell {
    
    @IBOutlet weak var sneakerImage: UIImageView!
    @IBOutlet weak var sneakerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
