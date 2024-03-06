//
//  ClinicalCompetenciesCell.swift
//  NCCAA
//
//  Created by Apple on 07/09/22.
//

import UIKit

class ClinicalCompetenciesCell: UITableViewCell {

    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblCaseDetail: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
