//
//  SearchResultCellView.swift
//  ClassProject
//
//  Created by Abe Johnson on 4/10/21.
//

import Foundation
import UIKit

class SearchResultCellView: UITableViewCell {
    
    // UI Outlet Variables
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var resultBrand: UILabel!
    @IBOutlet weak var resultName: UILabel!
    @IBOutlet weak var resultPrice: UILabel!
    @IBOutlet weak var resultReleased: UILabel!
    @IBOutlet weak var resultStyleID: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
