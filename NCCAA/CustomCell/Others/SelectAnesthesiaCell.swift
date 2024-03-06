//
//  SelectAnesthesiaCell.swift
//  NCCAA
//
//  Created by Apple on 19/10/22.
//

import UIKit

class SelectAnesthesiaCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCheckbox: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
