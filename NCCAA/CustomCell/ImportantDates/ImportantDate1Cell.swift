//
//  ImportantDate1Cell.swift
//  NCCAA
//
//  Created by Apple on 08/07/22.
//

import UIKit

class ImportantDate1Cell: UITableViewCell {

    
    @IBOutlet weak var btnUploadCME: UIButton!
    @IBOutlet weak var lblExamTitle: UILabel!
    @IBOutlet weak var lblExmDeadline: UILabel!
    @IBOutlet weak var lblExmLate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
