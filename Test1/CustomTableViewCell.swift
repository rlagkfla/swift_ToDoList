//
//  CustomTableViewCell.swift
//  Test1
//
//  Created by t2023-m0067 on 2023/08/09.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var customLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
