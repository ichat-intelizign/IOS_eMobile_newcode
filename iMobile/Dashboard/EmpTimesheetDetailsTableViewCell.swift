//
//  EmpTimesheetDetailsTableViewCell.swift
//  iMobile
//
//  Created by Rahul Maurya on 28/03/18.
//  Copyright © 2018 Rahul Maurya. All rights reserved.
//

import UIKit
import Dodo
class EmpTimesheetDetailsTableViewCell: UITableViewCell {
    var arrRealvalues2 = [getdatewiseTimesheet]()
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btncheckUncheck: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
        // Initialization code
    }
    func fillCollectionView(with array: [Any]) {
        //arrRealvalues2.removeAll()
        for obj in array {
            print(obj)
            let newItem = getdatewiseTimesheet()
            if let val = (obj as AnyObject).value(forKey: "timesheet_id") as? Int {
                newItem.timeSheet_id = "\(val)";
            }
            if let val = (obj as AnyObject).value(forKey: "activity") as? String {
                newItem.activity = "\(val)";
            }
            if let val = (obj as AnyObject).value(forKey: "isHalfDayLeaveRequested") as? Bool {
                newItem.isHalfDayLeaveRequested = val;
            }
            if let val = (obj as AnyObject).value(forKey: "hours") as? Int {
                newItem.hours = "\(val)";
            }
            if let val = (obj as AnyObject).value(forKey: "dayofWeek") as? String {
                newItem.dayOfWeek = "\(val)";
            }
            if let val = (obj as AnyObject).value(forKey: "isFullDayLeaveRequested") as? Bool {
                newItem.isFullDayLeaveRequested = val;
            }
            if let val = (obj as AnyObject).value(forKey: "isHoliday") as? Bool {
                newItem.isHoliday = val;
            }
            if let val = (obj as AnyObject).value(forKey: "isFullDayLeaveApproved") as? Bool {
                newItem.isFullDayLeaveApproved = val;
            }
            if let val = (obj as AnyObject).value(forKey: "dateofDay") as? String {
                newItem.dateOfDay = val;
            }
            if let val = (obj as AnyObject).value(forKey: "timesheetFilledByUsername") as? String {
                newItem.timesheetFilledByUserName = val;
            }
            if let val = (obj as AnyObject).value(forKey: "timesheetFilledByusertime") as? String {
                newItem.timesheetFilledByUserTime = val;
            }
            if let val = (obj as AnyObject).value(forKey: "isHalfDayLeaveApproved") as? Bool {
                newItem.isHalfDayLeaveApproved = val;
            }
            arrRealvalues2.append(newItem)
        }

        print(self.arrRealvalues2.count)
        self.collectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension EmpTimesheetDetailsTableViewCell {

    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {

        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.setContentOffset(collectionView.contentOffset, animated:false) // Stops collection view if it was scrolling.
        collectionView.reloadData()
    }

    var collectionViewOffset: CGFloat {
        set { collectionView.contentOffset.x = newValue }
        get { return collectionView.contentOffset.x }
    }
}
extension EmpTimesheetDetailsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrRealvalues2.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmpDetailsCollectionViewCell", for: indexPath) as! EmpDetailsCollectionViewCell
        //   cell.lblDate.text = "\(obj.dayOfWeek) \(obj.dateOfDay)"
        let obj = arrRealvalues2[indexPath.item] as getdatewiseTimesheet

        cell.lblhours.text = obj.dateOfDay.components(separatedBy: "/").first
        cell.btnColors.setTitle(obj.hours, for: UIControlState.normal)

        //  cell.lblModificationTime.text = "Modification Time :- \(obj.timesheetFilledByUserTime)"
        //        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "dd/MM/yyyy"
        //        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        //        let date = dateFormatter.date(from: obj.dateOfDay)
        //        let today = NSDate()
        //
        //        let Monday = Calendar.current.component(.weekday, from: date!)
        //        print("monday\(Monday)")
        //        let isMonday =  7
        //        let isMonday2 = 1

        //        cell.btnColors.addTarget(self, action: #selector(TimeSheetViewController.btnFillTime(sender:)), for: .touchUpInside)
        cell.btnColors.tag = indexPath.row


        // dateFormatter.dateFormat = "ccc"

                    if obj.isFullDayLeaveApproved == true {
                        cell.btnColors.backgroundColor = UIColor(rgb: 0xf3fa87, alphaVal: 1)
                    } else if obj.isHoliday == true {
                        cell.btnColors.backgroundColor = UIColor(rgb: 0xcc66ff, alphaVal: 1)

                    } else if obj.isHalfDayLeaveApproved == true {
                        cell.btnColors.backgroundColor = UIColor(rgb: 0x9fd8fc, alphaVal: 1)

                  }
                        else if obj.hours > "0" {
                        cell.btnColors.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
                    }
                    else if obj.isHalfDayLeaveRequested == true {
                        cell.btnColors.backgroundColor = UIColor(rgb: 0xffac30, alphaVal: 1)

                    } else if obj.isFullDayLeaveRequested == true {
                        cell.btnColors.backgroundColor = UIColor(rgb: 0xffac30, alphaVal: 1)

                    } else  if obj.dayOfWeek == "Saturday" || obj.dayOfWeek == "Sunday" {
                        cell.btnColors.backgroundColor = UIColor(rgb: 0xbbbbbb, alphaVal: 1)
                    } else if obj.activity == "Future Date" || obj.activity == "Inaccessible Month" {
                        cell.btnColors.backgroundColor = UIColor(rgb: 0xffffff, alphaVal: 1)
                    }
                    else {
                        cell.btnColors.backgroundColor = UIColor(rgb: 0xfc5b5b, alphaVal: 1)
                    }



        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = arrRealvalues2[indexPath.item] as getdatewiseTimesheet

        if obj.isFullDayLeaveApproved == true {
            self.dodo.style.leftButton.icon = .close

            // Supply your image
            self.dodo.style.leftButton.image = UIImage(named: "CloseIcon")

            // Change button's image color
            self.dodo.style.leftButton.tintColor = UIColor.white

            // Do something on tap
            self.dodo.style.leftButton.onTap = { /* Button tapped */ }

            // Close the bar when the button is tapped
            self.dodo.style.leftButton.hideOnTap = true
            self.dodo.topAnchor = self.safeAreaLayoutGuide.topAnchor
            self.dodo.error("Comment : \(obj.activity)")
            self.dodo.style.bar.hideAfterDelaySeconds = 10
            self.dodo.style.bar.hideOnTap = true

        } else if obj.isHoliday == true {
            self.dodo.style.leftButton.icon = .close

            // Supply your image
            self.dodo.style.leftButton.image = UIImage(named: "CloseIcon")

            // Change button's image color
            self.dodo.style.leftButton.tintColor = UIColor.white

            // Do something on tap
            self.dodo.style.leftButton.onTap = { /* Button tapped */ }

            // Close the bar when the button is tapped
            self.dodo.style.leftButton.hideOnTap = true
            self.dodo.topAnchor = self.safeAreaLayoutGuide.topAnchor
            self.dodo.error("Comment : \(obj.activity)")
            self.dodo.style.bar.hideAfterDelaySeconds = 10
            self.dodo.style.bar.hideOnTap = true

        } else if obj.isHalfDayLeaveApproved == true {
            self.dodo.style.leftButton.icon = .close

            // Supply your image
            self.dodo.style.leftButton.image = UIImage(named: "CloseIcon")

            // Change button's image color
            self.dodo.style.leftButton.tintColor = UIColor.white

            // Do something on tap
            self.dodo.style.leftButton.onTap = { /* Button tapped */ }

            // Close the bar when the button is tapped
            self.dodo.style.leftButton.hideOnTap = true
            self.dodo.topAnchor = self.safeAreaLayoutGuide.topAnchor
            self.dodo.error("Comment : \(obj.activity)")
            self.dodo.style.bar.hideAfterDelaySeconds = 10
            self.dodo.style.bar.hideOnTap = true

        }
            //         else if obj.hours > "0" {
            //                        cell.btnColors.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
            //                    }
        else if obj.isHalfDayLeaveRequested == true {
            self.dodo.style.leftButton.icon = .close

            // Supply your image
            self.dodo.style.leftButton.image = UIImage(named: "CloseIcon")

            // Change button's image color
            self.dodo.style.leftButton.tintColor = UIColor.white

            // Do something on tap
            self.dodo.style.leftButton.onTap = { /* Button tapped */ }

            // Close the bar when the button is tapped
            self.dodo.style.leftButton.hideOnTap = true
            self.dodo.topAnchor = self.safeAreaLayoutGuide.topAnchor
            self.dodo.error("Comment : \(obj.activity)")
            self.dodo.style.bar.hideAfterDelaySeconds = 10
            self.dodo.style.bar.hideOnTap = true

        } else if obj.isFullDayLeaveRequested == true {
            self.dodo.style.leftButton.icon = .close

            // Supply your image
            self.dodo.style.leftButton.image = UIImage(named: "CloseIcon")

            // Change button's image color
            self.dodo.style.leftButton.tintColor = UIColor.white

            // Do something on tap
            self.dodo.style.leftButton.onTap = { /* Button tapped */ }

            // Close the bar when the button is tapped
            self.dodo.style.leftButton.hideOnTap = true
            self.dodo.topAnchor = self.safeAreaLayoutGuide.topAnchor
            self.dodo.error("Comment : \(obj.activity)")
            self.dodo.style.bar.hideAfterDelaySeconds = 10
            self.dodo.style.bar.hideOnTap = true

        } else {
            if obj.activity != "" {
                self.dodo.style.leftButton.icon = .close

                // Supply your image
                self.dodo.style.leftButton.image = UIImage(named: "CloseIcon")

                // Change button's image color
                self.dodo.style.leftButton.tintColor = UIColor.white

                // Do something on tap
                self.dodo.style.leftButton.onTap = { /* Button tapped */ }

                // Close the bar when the button is tapped
                self.dodo.style.leftButton.hideOnTap = true
                self.dodo.topAnchor = self.safeAreaLayoutGuide.topAnchor
                self.dodo.error("Comment : \(obj.activity)")
                self.dodo.style.bar.hideAfterDelaySeconds = 10
                self.dodo.style.bar.hideOnTap = true
            }

        }

        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}
