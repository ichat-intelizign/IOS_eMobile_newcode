//
//  EmployeeLeaveViewController.swift
//  iMobile
//
//  Created by Rahul Maurya on 02/04/18.
//  Copyright © 2018 Rahul Maurya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftLoader
import EFInternetIndicator
import IQKeyboardManagerSwift
class EmployeeLeaveViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,InternetStatusIndicable,UITextViewDelegate {
    var internetConnectionIndicator: InternetViewIndicator?
    var arrbulLeaves = [getbulkEmpLeaves]()

    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.layer.cornerRadius = 3
            bottomView.layer.borderWidth = 1
            bottomView.layer.borderColor = UIColor.lightGray.cgColor
        }
    }

    @IBOutlet weak var txtview: UITextView! {
        didSet {
            txtview.layer.borderColor = UIColor.darkGray.cgColor
            //  txtViewComment.sizeToFit()
            // border.frame = CGRect(x: 0, y: txtViewComment.frame.size.height - width, width:  txtViewComment.frame.size.width, height: txtViewComment.frame.size.height)
            txtview.layer.cornerRadius = 3
            txtview.layer.borderWidth = 1
            //  txtViewComment.layer.addSublayer(border)
            txtview.layer.masksToBounds = true

        }
    }

    @IBOutlet weak var btnSelectAll: UIButton!

    @IBOutlet weak var btnReject: UIButton! {
        didSet {
            btnReject.layer.cornerRadius = 6
            btnReject.layer.borderWidth = 1
            btnReject.clipsToBounds = true;
            btnReject.layer.borderColor = UIColor(red: 237/255, green: 122/255, blue: 43/255, alpha: 1.0).cgColor
        }
    }

    @IBOutlet weak var btnApprove: UIButton! {
        didSet {
            btnApprove.layer.cornerRadius = 6
            btnApprove.clipsToBounds = true;
            btnApprove.layer.borderWidth = 1
            btnApprove.layer.borderColor = UIColor(red: 237/255, green: 122/255, blue: 43/255, alpha: 1.0).cgColor
        }
    }

    @IBOutlet weak var btnNext: UIButton!

    @IBOutlet weak var btnBack: UIButton!

    @IBOutlet weak var tblEmpLEaves: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Employee Leave"
        txtview.text = "Please Enter Comment ...."
        txtview.textColor = UIColor.lightGray

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
        getBulkEMpleaves()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"sinchronize"), style: .plain, target: self, action: #selector(menuButtonTapped(sender:)))
        IQKeyboardManager.sharedManager().enable = true

        // Do any additional setup after loading the view.
    }
    @objc func menuButtonTapped(sender: UIBarButtonItem) {
        arrbulLeaves.removeAll()

        getBulkEMpleaves()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
     func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Please Enter Comment ...."
            textView.textColor = UIColor.lightGray
        }
    }

    func getBulkEMpleaves() {
        self.startMonitoringInternet()
        SwiftLoader.show(title: "Loading...", animated: true)
        let todosEndpoint: String = MAINURL + "BulkEmployeeLeaveRequestDetails"
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

                        if json["Response"] != nil{
                            DispatchQueue.main.async {
                               let contact = JSON.init(parseJSON: json["Response"] as! String)

                                let keys = contact.flatMap(){ $0.0 as? String }
                                for obj in contact.arrayValue {
                                    let newitem = getbulkEmpLeaves()
                                    newitem.leaveTotalDays = "\(obj["leaveTotalDays"])"
                                    newitem.leaveType = "\(obj["leaveType"])"
                                    newitem.leaveAvailable = "\(obj["leaveAvailable"])"
                                    newitem.leaveComment = "\(obj["leaveComment"])"
                                    newitem.leaveDate = "\(obj["leaveDate"])"
                                    newitem.leaveDayType = "\(obj["leaveDayType"])"
                                    newitem.empName = "\(obj["empName"])"
                                    newitem.leaveReqId = "\(obj["leaveReqId"])"
                                    self.arrbulLeaves.append(newitem)
                                }
                                self.tblEmpLEaves.reloadData()
                                print(result)
                                print(contact )
                               
                            }
                        }
                    }


                }

        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfSection: Int = 0

        if arrbulLeaves.count > 0 {
             self.bottomView.isHidden = false
            self.tblEmpLEaves.backgroundView = nil
            numOfSection = arrbulLeaves.count
            tblEmpLEaves.separatorStyle = .singleLine


        } else {
            self.bottomView.isHidden = true
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tblEmpLEaves.bounds.size.width, height: self.tblEmpLEaves.bounds.size.height))
            // UILabel(frame: CGRectMake(0, 0, self.tblLeaves.bounds.size.width, self.tblLeaves.bounds.size.height))
            noDataLabel.text = "Leave requested count : 0"
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tblEmpLEaves.backgroundView = noDataLabel
            tblEmpLEaves.separatorStyle = .none

        }
        return numOfSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell : EmployeeLeaveTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmployeeLeaveTableViewCell" , for:indexPath) as! EmployeeLeaveTableViewCell
        let obj = arrbulLeaves[indexPath.row] as getbulkEmpLeaves
        cell.lblLeaveType.text = "\(obj.leaveType) : \(obj.leaveDayType)"
        cell.lblName.text = obj.empName
        cell.lblDates.text = "Date: \(obj.leaveDate)"
        cell.lblTotaldays.text = "Total Days: \(obj.leaveTotalDays)"
        cell.lblCommits.text = "Comment: \(obj.leaveComment)"
        if obj.flag == true {
            cell.imgSelect.image = UIImage(named: "check-mark")
        } else {
             cell.imgSelect.image = UIImage(named: "square-outline")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
       // flagbtncheck = true
        //  let cell : EmpTimesheetDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmpTimesheetDetailsTableViewCell" , for:indexPath) as! EmpTimesheetDetailsTableViewCell
        //


        let obj = arrbulLeaves[indexPath.row] as getbulkEmpLeaves
        if obj.flag == true {
            obj.flag = false
        } else {
            obj.flag = true
        }

        self.tblEmpLEaves.reloadData()


    }
    

    @IBAction func btnApproveAction(_ sender: Any) {
        var count : Bool = false
        var arroftimesheetdate = [String]()
        //   var arrayOfArray = [Array<Any>]()
        for i in 0 ..< arrbulLeaves.count {

            let obj = arrbulLeaves[i] as getbulkEmpLeaves
            if obj.flag == true {

                        count = true
                    arroftimesheetdate.append(obj.leaveReqId)

            }

        }
        if count == false {
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
            self.view.dodo.error("Please select leave.")
            self.view.dodo.style.bar.hideAfterDelaySeconds = 10
            self.view.dodo.style.bar.hideOnTap = true

        } else if self.txtview.text == "Please Enter Comment ...." || self.txtview.text == ""{

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
            self.view.dodo.error("Please enter comment.")
            self.view.dodo.style.bar.hideAfterDelaySeconds = 10
            self.view.dodo.style.bar.hideOnTap = true
            
        } else {
            let refreshAlert = UIAlertController(title: "", message: "Do you relly want to Approve selected Leave?", preferredStyle: UIAlertControllerStyle.actionSheet)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                print("arroftimesheetdate\(arroftimesheetdate)")
                //        var error:NSError?
                //        let joined = arroftimesheetdate.joined(separator: ", ")
                //        print(joined)
                //
                let data = try? JSONSerialization.data(withJSONObject: arroftimesheetdate, options: [])
                let strReID = String(data:data!, encoding: String.Encoding.utf8)

                print("\(strReID!)")

                self.startMonitoringInternet()
                SwiftLoader.show(title: "Loading...", animated: true)
                let todosEndpoint: String = MAINURL + "BulkEmployeeLeavesApproveReject"
                let newTodo: [String: Any] = ["userName": UserDefaults.standard.string(forKey: "username") ?? "","password": UserDefaults.standard.string(forKey: "password") ?? "","selectedEmpLeaveReqIdsList":strReID ?? "","mgrStatus":"Approved","mgrComment":self.txtview.text]
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
                                        self.view.dodo.success("Leave approved successfully.")
                                        self.view.dodo.style.bar.hideAfterDelaySeconds = 10
                                        self.view.dodo.style.bar.hideOnTap = true
                                        self.arrbulLeaves.removeAll()
                                        self.txtview.text = ""
                                        self.getBulkEMpleaves()

                                        //  self.tblHistory.reloadData()

                                    }
                                }
                            } else {

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
                                    self.view.dodo.error("Leave Submission Failed!")
                                    self.view.dodo.style.bar.hideAfterDelaySeconds = 10
                                    self.view.dodo.style.bar.hideOnTap = true

                                }

                            }


                        }

                }
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)


        }


    }

    @IBAction func btnrejectAction(_ sender: Any) {
        var count : Bool = false
        var arroftimesheetdate = [String]()
        //   var arrayOfArray = [Array<Any>]()
        for i in 0 ..< arrbulLeaves.count {

            let obj = arrbulLeaves[i] as getbulkEmpLeaves
            if obj.flag == true {

                count = true
                arroftimesheetdate.append(obj.leaveReqId)

            }

        }
        if count == false {
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
            self.view.dodo.error("Please select leave.")
            self.view.dodo.style.bar.hideAfterDelaySeconds = 10
            self.view.dodo.style.bar.hideOnTap = true

        } else if self.txtview.text == "Please Enter Comment ...." || self.txtview.text == "" {

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
            self.view.dodo.error("Please enter comment.")
            self.view.dodo.style.bar.hideAfterDelaySeconds = 10
            self.view.dodo.style.bar.hideOnTap = true

        } else {
            let refreshAlert = UIAlertController(title: "", message: "Do you really want to reject selected Leave?", preferredStyle: UIAlertControllerStyle.actionSheet)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                print("arroftimesheetdate\(arroftimesheetdate)")
                //        var error:NSError?
                //        let joined = arroftimesheetdate.joined(separator: ", ")
                //        print(joined)
                //
                let data = try? JSONSerialization.data(withJSONObject: arroftimesheetdate, options: [])
                let strReID = String(data:data!, encoding: String.Encoding.utf8)

                print("\(strReID!)")

                self.startMonitoringInternet()
                SwiftLoader.show(title: "Loading...", animated: true)
                let todosEndpoint: String = MAINURL + "BulkEmployeeLeavesApproveReject"
                let newTodo: [String: Any] = ["userName": UserDefaults.standard.string(forKey: "username") ?? "","password": UserDefaults.standard.string(forKey: "password") ?? "","selectedEmpLeaveReqIdsList":strReID ?? "","mgrStatus":"Rejected","mgrComment":self.txtview.text]
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
                                       self.view.dodo.success("Leave rejected successfully.")
                                        self.view.dodo.style.bar.hideAfterDelaySeconds = 10
                                        self.view.dodo.style.bar.hideOnTap = true
                                        self.arrbulLeaves.removeAll()
                                        self.txtview.text = ""
                                        self.getBulkEMpleaves()

                                        //  self.tblHistory.reloadData()

                                    }
                                }
                            } else {

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
                                    self.view.dodo.error("Leave Submission Failed!")
                                    self.view.dodo.style.bar.hideAfterDelaySeconds = 10
                                    self.view.dodo.style.bar.hideOnTap = true

                                }

                            }


                        }

                }
            }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))

            present(refreshAlert, animated: true, completion: nil)


        }

    }

    @IBAction func btnSelectAllAction(_ sender: UIButton) {
        if sender.tag == 0 {
             btnSelectAll.setBackgroundImage(UIImage(named: "check-mark"), for: UIControlState.normal)
            sender.tag  = 1
            for i in 0 ..< arrbulLeaves.count {
                let obj = arrbulLeaves[i] as getbulkEmpLeaves
                if obj.flag == false {
                    obj.flag = true
                }
            }
        } else {
            btnSelectAll.setBackgroundImage(UIImage(named: "square-outline"), for: UIControlState.normal)
            for i in 0 ..< arrbulLeaves.count {
                let obj = arrbulLeaves[i] as getbulkEmpLeaves
                if obj.flag == true {
                    obj.flag = false
                }
            }
            sender.tag  = 0
        }

        tblEmpLEaves.reloadData()
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
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
