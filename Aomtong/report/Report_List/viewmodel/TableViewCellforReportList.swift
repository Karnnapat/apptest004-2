//
//  TableViewCellforReportList.swift
//  Aomtung
//
//  Created by Karnnapat Kamolwisutthipong on 15/2/2567 BE.
//

import UIKit

class TableViewCellforReportList: UITableViewCell {

    
    @IBOutlet weak var lb_time: UILabel!
    @IBOutlet weak var lb_total: UILabel!
    @IBOutlet weak var lb_DataType: UILabel!
    @IBOutlet weak var lb_AccountType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
