//
//  SubCategoriesCell.swift
//  NCCAA
//
//  Created by Apple on 07/09/22.
//

import UIKit

class SubCategoriesCell: UITableViewCell {

    
    @IBOutlet weak var lblSign: UILabel!
    @IBOutlet weak var btnTap: UIButton!
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var lblCompleted: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var widthImgTick: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
