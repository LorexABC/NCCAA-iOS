//
//  ButtonCell.swift
//  NCCAA
//
//  Created by Apple on 01/10/22.
//

import UIKit

class ButtonCell: UITableViewCell {

    
    @IBOutlet weak var btn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
