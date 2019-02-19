//
//  LeaveAvailabilityTableViewCell.swift
//  iMobile
//
//  Created by Rahul Maurya on 20/03/18.
//  Copyright © 2018 Rahul Maurya. All rights reserved.
//

import UIKit

class LeaveAvailabilityTableViewCell: UITableViewCell {

    @IBOutlet weak var lblLeaveType: UILabel!

    @IBOutlet weak var lblRemainingLeave: UILabel!

    @IBOutlet weak var lblTotalLeaves: UILabel!
    
    @IBOutlet weak var lblActivePeriods: UILabel!
    @IBOutlet weak var lblCarryFor: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
