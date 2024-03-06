//
//  ImportantDate2Cell.swift
//  NCCAA
//
//  Created by Apple on 08/07/22.
//

import UIKit

class ImportantDate2Cell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblRegistration: UILabel!
    @IBOutlet weak var lblLate: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
