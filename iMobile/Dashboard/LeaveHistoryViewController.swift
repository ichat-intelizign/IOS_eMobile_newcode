//
//  LeaveHistoryViewController.swift
//  iMobile
//
//  Created by Rahul Maurya on 21/03/18.
//  Copyright © 2018 Rahul Maurya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftLoader
import SwiftyJSON
import EFInternetIndicator
class LeaveHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,InternetStatusIndicable {
    var internetConnectionIndicator: InternetViewIndicator?

    @IBOutlet weak var tblHistory: UITableView!
    var arrLeaves = [getLeaveshistorymodel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Leave History"
        let button: UIButton = UIButton(type: UIButtonType.custom)
        //set image for button
        button.setImage(UIImage(named: "menu1"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(SSASideMenu.presentLeftMenuViewController), for: UIControlEvents.touchUpInside)
        //set frame
        //  button.frame = CGRectMake(0, 0, 53, 31)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.leftBarButtonItem = barButton
        getleaveHistory()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"sinchronize"), style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        // Do any additional setup after loading the view.
    }

    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        arrLeaves.removeAll()

       getleaveHistory()
    }
    func getleaveHistory() {
        self.startMonitoringInternet()
        SwiftLoader.show(title: "Loading...", animated: true)
        let todosEndpoint: String = MAINURL + "LeaveHistoryDetails"
        let newTodo: [String: Any] = ["userName": UserDefaults.standard.string(forKey: "username") ?? "","password": UserDefaults.standard.string(forKey: "password") ?? ""]
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                SwiftLoader.hide()
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 201:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    if json["Result"] as? Bool == true {
                        //let null = json["Response"] is NSNull
                        let val = json["Response"] as? String//"[null]"
                        if self.isNsnullOrNil(object: val as Any) == true{
                            DispatchQueue.main.async {
                                let contact = JSON.init(parseJSON: (json["Response"] as? String)!)
                                print(result)
                                print(contact)
                                for obj in contact.arrayValue{
                                    let newItem = getLeaveshistorymodel()
                                    newItem.dayType = "\(obj["dayType"])"
                                    newItem.Leavedates = "\(obj["Leavedates"])"
                                    newItem.statusChangeTime = "\(obj["statusChangeTime"])"
                                    newItem.status = "\(obj["status"])"
                                    newItem.leaveReqBy = "\(obj["leaveReqBy"])"
                                    newItem.comment = "\(obj["comment"])"
                                    newItem.leaveReqTime = "\(obj["leaveReqTime"])"
                                    newItem.statusChangeBy = "\(obj["statusChangeBy"])"
                                    newItem.totalLeaves = "\(obj["totalLeaves"])"
                                    newItem.leavetype = "\(obj["leavetype"])"
                                    newItem.leaveReqId = "\(obj["leaveReqId"])"
                                    self.arrLeaves.append(newItem);
                                }

                                self.tblHistory.reloadData()
                            }
                        }
                    }


                }

        }
    }
    func isNsnullOrNil(object : Any) -> Bool
    {
        if (object as! String == "[null]")
        {
            return false
        }
        else
        {
            return true
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfSection: Int = 0

        if arrLeaves.count > 0 {

            self.tblHistory.backgroundView = nil
            numOfSection = arrLeaves.count
            tblHistory.separatorStyle = .singleLine


        } else {

            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tblHistory.bounds.size.width, height: self.tblHistory.bounds.size.height))
            // UILabel(frame: CGRectMake(0, 0, self.tblLeaves.bounds.size.width, self.tblLeaves.bounds.size.height))
            noDataLabel.text = "No History Available"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tblHistory.backgroundView = noDataLabel
            tblHistory.separatorStyle = .none

        }
        return numOfSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : LeaveHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "LeaveHistoryTableViewCell" , for:indexPath) as! LeaveHistoryTableViewCell
        let obj = arrLeaves[indexPath.row] as getLeaveshistorymodel
//        if let font = UIFont(name: "Roboto", size: 14) {
//            let mutableAttributedString = NSMutableAttributedString()
//          //  let font2 = UIFont(name: "Roboto", size: 14)
//            let s = NSAttributedString(string: obj.status, attributes: [ NSAttributedStringKey.font: font.italic() ])
//            //let c = NSAttributedString(string: "Comment: ", attributes: [ NSAttributedStringKey.font: font2 ?? ""])
//          //  mutableAttributedString.append(c)
//            mutableAttributedString.append(s)
//            cell.lblLeaveStatus.attributedText = mutableAttributedString
//        }
        cell.lblLeaveStatus.text = obj.status
        if let font = UIFont(name: "Roboto", size: 14) {
            let mutableAttributedString = NSMutableAttributedString()
             let font2 = UIFont(name: "Roboto", size: 14)
            let s = NSAttributedString(string: obj.leavetype, attributes: [ NSAttributedStringKey.font: font.italic() ])
            let c = NSAttributedString(string: "Leave Type : ", attributes: [ NSAttributedStringKey.font: font2 ?? ""])
            mutableAttributedString.append(c)
            mutableAttributedString.append(s)
            cell.lblSickleave.attributedText = mutableAttributedString
        }

       // cell.lblSickleave.text = "Leave Type:- \(obj.leavetype)"
        if let font = UIFont(name: "Roboto", size: 14) {
            let mutableAttributedString = NSMutableAttributedString()
            let font2 = UIFont(name: "Roboto", size: 14)
            let s = NSAttributedString(string: obj.comment, attributes: [ NSAttributedStringKey.font: font.italic() ])
            let c = NSAttributedString(string: "Comment : ", attributes: [ NSAttributedStringKey.font: font2 ?? ""])
            mutableAttributedString.append(c)
            mutableAttributedString.append(s)
             cell.lblComments.attributedText = mutableAttributedString
        }

        if let font = UIFont(name: "Roboto", size: 14) {
            let mutableAttributedString = NSMutableAttributedString()
            let font2 = UIFont(name: "Roboto", size: 14)
            let s = NSAttributedString(string: obj.statusChangeBy.capitalized, attributes: [ NSAttributedStringKey.font: font.italic() ])
            let c = NSAttributedString(string: "Approve/Rejected By : ", attributes: [ NSAttributedStringKey.font: font2 ?? ""])
            mutableAttributedString.append(c)
            mutableAttributedString.append(s)
            cell.lblApproveReject.attributedText = mutableAttributedString
        }

           // cell.lblApproveReject.text = "Approve/Rejected By:- \(obj.statusChangeBy)".capitalized
       // cell.lblDate.text = "Date:- \(obj.Leavedates)"
        if let font = UIFont(name: "Roboto", size: 14) {
            let mutableAttributedString = NSMutableAttributedString()
            let font2 = UIFont(name: "Roboto", size: 14)
            let s = NSAttributedString(string: obj.Leavedates, attributes: [ NSAttributedStringKey.font: font.italic() ])
            let c = NSAttributedString(string: "Date : ", attributes: [ NSAttributedStringKey.font: font2 ?? ""])
            mutableAttributedString.append(c)
            mutableAttributedString.append(s)
            cell.lblDate.attributedText = mutableAttributedString
        }
        cell.lblTotalDays.text = "\(obj.totalLeaves) day(s)"
        if obj.status == "Requested" {
            cell.btnCancel.addTarget(self, action: #selector(LeaveHistoryViewController.connected(sender:)), for: .touchUpInside)
            cell.btnCancel.tag = indexPath.row
            cell.btnCancel.isHidden = false
        } else {
            cell.btnCancel.isHidden = true
        }
        return cell
    }

    @objc func connected(sender: UIButton){
        print("btn click")
        let buttonTag = sender.tag
        cancelLeave(tag: buttonTag)

    }
    func cancelLeave(tag : Int) {
        let refreshAlert = UIAlertController(title: "", message: "Do you really want to Cancel Leave?", preferredStyle: UIAlertControllerStyle.actionSheet)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            let obj = self.arrLeaves[tag] as getLeaveshistorymodel
            let fromdate = obj.Leavedates.components(separatedBy: " ").first
            let todate = obj.Leavedates.components(separatedBy: " ").last
            self.startMonitoringInternet()
            SwiftLoader.show(title: "Loading...", animated: true)
            let todosEndpoint: String = MAINURL + "UserLeaveCancel"
            let newTodo: [String: Any] = ["userName": UserDefaults.standard.string(forKey: "username") ?? "","password": UserDefaults.standard.string(forKey: "password") ?? "","leaveType":obj.leavetype,"dayType":obj.dayType,"leaveFromDate":fromdate ?? "","leaveTodate":todate ?? "","leaveRequestId":obj.leaveReqId]
            Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response)
                    SwiftLoader.hide()
                    //to get status code
                    if let status = response.response?.statusCode {
                        switch(status){
                        case 201:
                            print("example success")
                        default:
                            print("error with response status: \(status)")
                        }
                    }
                    //to get JSON return value
                    if let result = response.result.value {
                        let json = result as! NSDictionary
                        if json["Result"] as? Bool == true {
                            if json["Response"] != nil {
                                DispatchQueue.main.async {
                                    let contact = json["Response"] as! String
                                    print("response for leave reuest\(contact)")
                                    self.view.dodo.style.leftButton.icon = .close

                                    // Supply your image
                                    self.view.dodo.style.leftButton.image = UIImage(named: "CloseIcon")

                                    // Change button's image color
                                    self.view.dodo.style.leftButton.tintColor = UIColor.white

                                    // Do something on tap
                                    self.view.dodo.style.leftButton.onTap = { /* Button tapped */ }

                                    // Close the bar when the button is tapped
                                    self.view.dodo.style.leftButton.hideOnTap = true
                                    self.view.dodo.topAnchor = self.view.safeAreaLayoutGuide.topAnchor
                                    self.view.dodo.success(contact)
                                    self.view.dodo.style.bar.hideAfterDelaySeconds = 10
                                    self.view.dodo.style.bar.hideOnTap = true
                                    self.arrLeaves.removeAll()
                                    self.getleaveHistory()
                                    //  self.tblHistory.reloadData()

                                }
                            }
                        } else {
                            if json["Response"] != nil {
                                DispatchQueue.main.async {
                                    let contact = json["Response"] as! String
                                    print("response for leave reuest\(contact)")
                                    self.view.dodo.style.leftButton.icon = .close

                                    // Supply your image
                                    self.view.dodo.style.leftButton.image = UIImage(named: "CloseIcon")

                                    // Change button's image color
                                    self.view.dodo.style.leftButton.tintColor = UIColor.white

                                    // Do something on tap
                                    self.view.dodo.style.leftButton.onTap = { /* Button tapped */ }

                                    // Close the bar when the button is tapped
                                    self.view.dodo.style.leftButton.hideOnTap = true
                                    self.view.dodo.topAnchor = self.view.safeAreaLayoutGuide.topAnchor
                                    self.view.dodo.error(contact)
                                    self.view.dodo.style.bar.hideAfterDelaySeconds = 10
                                    self.view.dodo.style.bar.hideOnTap = true

                                }
                            }
                        }


                    }
                    else {
                        self.view.dodo.style.leftButton.icon = .close

                        // Supply your image
                        self.view.dodo.style.leftButton.image = UIImage(named: "CloseIcon")

                        // Change button's image color
                        self.view.dodo.style.leftButton.tintColor = UIColor.white

                        // Do something on tap
                        self.view.dodo.style.leftButton.onTap = { /* Button tapped */ }

                        // Close the bar when the button is tapped
                        self.view.dodo.style.leftButton.hideOnTap = true
                        self.view.dodo.topAnchor = self.view.safeAreaLayoutGuide.topAnchor
                        self.view.dodo.error("Something went wrong")
                        self.view.dodo.style.bar.hideAfterDelaySeconds = 10
                        self.view.dodo.style.bar.hideOnTap = true
                    }

            }
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))

        present(refreshAlert, animated: true, completion: nil)

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIFont {

    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }

}
