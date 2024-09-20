//
//  TableViewCell.swift
//  bluetooth
//
//  Created by imac 1682's MacBook Pro on 2024/9/20.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var lbcellssee: UILabel!
    
    static let identifier = "TableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
