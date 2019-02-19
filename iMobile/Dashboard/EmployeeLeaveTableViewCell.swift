//
//  EmployeeLeaveTableViewCell.swift
//  iMobile
//
//  Created by Rahul Maurya on 02/04/18.
//  Copyright © 2018 Rahul Maurya. All rights reserved.
//

import UIKit

class EmployeeLeaveTableViewCell: UITableViewCell {
    @IBOutlet weak var lblLeaveType: UILabel!
    @IBOutlet weak var lblCommits: UILabel!
    
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var lblTotaldays: UILabel!
    @IBOutlet weak var lblDates: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
