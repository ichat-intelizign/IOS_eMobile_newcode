//
//  EmpTImesheetTableViewCell.swift
//  iMobile
//
//  Created by Rahul Maurya on 27/03/18.
//  Copyright © 2018 Rahul Maurya. All rights reserved.
//

import UIKit

class EmpTImesheetTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet weak var lblID: UILabel!

    @IBOutlet weak var firstlbl: UILabel! {
        didSet {
            self.firstlbl.layer.cornerRadius = (firstlbl.frame.size.width)/2.0
            self.firstlbl.clipsToBounds = true
            self.firstlbl.layer.borderColor = UIColor.lightGray.cgColor
            self.firstlbl.layer.borderWidth = 2
            //firstlbl.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
        }
    }
    @IBOutlet weak var seclbl: UILabel! {
        didSet {
            self.seclbl.layer.cornerRadius = (seclbl.frame.size.width)/2.0
            self.seclbl.clipsToBounds = true
            self.seclbl.layer.borderColor = UIColor.lightGray.cgColor
            self.seclbl.layer.borderWidth = 2
             //seclbl.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
        }
    }
        @IBOutlet weak var thirdlbl: UILabel! {
        didSet {
        self.thirdlbl.layer.cornerRadius = (thirdlbl.frame.size.width)/2.0
        self.thirdlbl.clipsToBounds = true
        self.thirdlbl.layer.borderColor = UIColor.lightGray.cgColor
        self.thirdlbl.layer.borderWidth = 2
            //thirdlbl.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
        }
    }
        @IBOutlet weak var forthlbl: UILabel! {
        didSet {
        self.forthlbl.layer.cornerRadius = (forthlbl.frame.size.width)/2.0
        self.forthlbl.clipsToBounds = true
        self.forthlbl.layer.borderColor = UIColor.lightGray.cgColor
        self.forthlbl.layer.borderWidth = 2
            //forthlbl.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
        }
    }
        @IBOutlet weak var fifthlbl: UILabel! {
        didSet {
        self.fifthlbl.layer.cornerRadius = (fifthlbl.frame.size.width)/2.0
        self.fifthlbl.clipsToBounds = true
        self.fifthlbl.layer.borderColor = UIColor.lightGray.cgColor
        self.fifthlbl.layer.borderWidth = 2
            //fifthlbl.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

