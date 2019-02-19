//
//  EmployeeTimesheetDetailsViewController.swift
//  iMobile
//
//  Created by Rahul Maurya on 28/03/18.
//  Copyright © 2018 Rahul Maurya. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftLoader
import EFInternetIndicator
import Dodo
import Alamofire
class EmployeeTimesheetDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,InternetStatusIndicable {
    var internetConnectionIndicator: InternetViewIndicator?

    var dict : NSDictionary = [:]
    var arrkeys = [getkeysarr]()
    var arrDict = [Any]()
    var action : String?
    var arrRealvalues = [Any]()
    var flagbtncheck = false
    var EmpID : String?
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
    @IBOutlet weak var btnAllCheck: UIButton!
    var storedOffsets = [Int: CGFloat]()
    @IBOutlet weak var tblTimesheetDetails: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let keys = self.dict.flatMap(){ $0.0 as? String }
         let values = self.dict.flatMap(){ $0.1 }
        for obj in keys {
            let newitem = getkeysarr()
            newitem.keysv = "\(obj)"
            arrkeys.append(newitem)
        }




//        for obj in values {
//            arrDict.append(obj)
//        }
//        print("arrdict\(arrDict[0])")
//         let contact = JSON.init(parseJSON: arrDict[0] as! String)
//        print("contactarray -\(contact.array ?? [0])")
//
//
//        for obj in values {
//             let newItem = getdatewiseData()
//            //let newItem = getdatewiseData()
////            if let val = obj["timeSheet_id"] as? Any {
////                newItem.timeSheet_id = val as! String
////            }
////
////            newItem.hours = "\(obj["hours"])"
////            newItem.timesheetFilledByUserTime = "\(obj["timesheetFilledByUserTime"])"
////            newItem.dayOfWeek = "\(obj["dayOfWeek"])"
////            newItem.isFullDayLeaveApproved = "\(obj["isFullDayLeaveApproved"])"
////            newItem.activity = "\(obj["activity"])"
////            newItem.dateOfDay = "\(obj["dateOfDay"])"
////            newItem.isHoliday = "\(obj["isHoliday"])"
////            newItem.isFullDayLeaveRequested = "\(obj["isFullDayLeaveRequested"])"
////            newItem.isHalfDayLeaveRequested = "\(obj["isHalfDayLeaveRequested"])"
////            newItem.isHalfDayLeaveApproved = "\(obj["isHalfDayLeaveApproved"])"
////            newItem.timesheetFilledByUserName = "\(obj["timesheetFilledByUserName"])"
////            newItem.dateOfDay = "\(obj["dateOfDay"])"
//            arrRealvalues.append(obj)
//        }
         print("arrRealvalues -\(arrRealvalues)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrkeys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EmpTimesheetDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmpTimesheetDetailsTableViewCell" , for:indexPath) as! EmpTimesheetDetailsTableViewCell
         let obj1 = arrkeys[indexPath.row] as getkeysarr
        if flagbtncheck == true {
           // flagbtncheck = false
            if obj1.flag == true {
                cell.btncheckUncheck.setBackgroundImage(UIImage(named: "check-mark"), for: UIControlState.normal)
            } else {
                cell.btncheckUncheck.setBackgroundImage(UIImage(named: "square-outline"), for: UIControlState.normal)
            }

        } else {

            // let array = dict[obj1] as! NSArray
            let contact = JSON.init(parseJSON: dict[obj1.keysv] as! String)
            // let arrayOfAny:Array<Any>  = array as! Array<Any>
            cell.collectionView.tag = indexPath.row
            cell.fillCollectionView(with: contact.arrayObject!)
        }



        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        flagbtncheck = true
        //  let cell : EmpTimesheetDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmpTimesheetDetailsTableViewCell" , for:indexPath) as! EmpTimesheetDetailsTableViewCell
       //


        let obj = arrkeys[indexPath.row] as getkeysarr
        if obj.flag == true {
             obj.flag = false
        } else {
             obj.flag = true
        }

self.tblTimesheetDetails.reloadData()

       
    }
    


    
    @IBAction func btnAllcheckAction(_ sender: UIButton) {



         flagbtncheck = true
        if sender.tag == 0 {
             btnAllCheck.setBackgroundImage(UIImage(named: "check-mark"), for: UIControlState.normal)
            sender.tag  = 1
            for i in 0 ..< arrkeys.count {
                let obj = arrkeys[i] as getkeysarr
                if obj.flag == false {
                    obj.flag = true
                }
            }
        } else {
            btnAllCheck.setBackgroundImage(UIImage(named: "square-outline"), for: UIControlState.normal)

            for i in 0 ..< arrkeys.count {
                let obj = arrkeys[i] as getkeysarr
                if obj.flag == true {
                    obj.flag = false
                }
            }
            sender.tag  = 0
        }

        tblTimesheetDetails.reloadData()
    }

    @IBAction func btnapproveAction(_ sender: Any) {
        var count : Bool = false
        action = "Approve"
        var arroftimesheetdate = [String]()
        var arroftimefirstindex = [String]()

        var arrayOfArray = [Array<String>]()
        for i in 0 ..< arrkeys.count {

            let obj = arrkeys[i] as getkeysarr
            if obj.flag == true {
                  let contact = JSON.init(parseJSON: dict[obj.keysv] as! String)

                var myArray : [String] = []
                for obj in contact.arrayValue {
                   // arrobject.append(obj["dateofDay"])
                    myArray.append("\(obj["dateofDay"])")
                     count = true

                   //append(obj["dateofDay"])
                }

                  arrayOfArray.append(myArray)
            }

        }
         print("arroftimesheetdate\(arrayOfArray)")
        for (index,obj) in arrayOfArray.enumerated() {
             print("indexofindex\(index)")
                arroftimefirstindex.append(obj[0])
        }

        print("arroftimefirstindex\(arroftimefirstindex)")
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

        } else {
            let refreshAlert = UIAlertController(title: "", message: "Do you really want to approve selected timesheet?", preferredStyle: UIAlertControllerStyle.actionSheet)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                let data = try? JSONSerialization.data(withJSONObject: arroftimefirstindex, options: [])
                let str = String(data:data!, encoding: String.Encoding.utf8)

                print("\(str!)")
                //        let weekstring = json(from : arrayOfArray)
                //        print("weekstring\(weekstring ?? "")")

                self.startMonitoringInternet()
                SwiftLoader.show(title: "Loading...", animated: true)
                let todosEndpoint: String = MAINURL + "ApproveEmployeeTimesheet"
                let newTodo: [String: Any] = ["userName": UserDefaults.standard.string(forKey: "username") ?? "","password": UserDefaults.standard.string(forKey: "password") ?? "","selectedEmployeeId":self.EmpID ?? "","selectedTimesheetWeekList":str ?? "" ,"timesheetAction": "Approve"]
                print("newtodo\(newTodo)")
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
                                        self.view.dodo.style.leftButton.onTap = { /* Button tapped */self.navigationController?.popViewController(animated: true) }

                                        // Close the bar when the button is tapped
                                        self.view.dodo.style.leftButton.hideOnTap = true
                                        self.view.dodo.topAnchor = self.view.safeAreaLayoutGuide.topAnchor
                                        self.view.dodo.success(contact)
                                        // self.view.dodo.style.bar.hideAfterDelaySeconds = 10
                                        self.view.dodo.style.bar.hideOnTap = true


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
                                    self.view.dodo.error(contact)
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

        print("arroftimesheetdate\(arroftimesheetdate)")
//        var error:NSError?
//        let joined = arroftimesheetdate.joined(separator: ", ")
//        print(joined)
//

    }

    @IBAction func btnRejectAction(_ sender: Any) {
         action = "Reject"
        var count : Bool = false
        var arroftimesheetdate = [String]()
        var arroftimefirstindex = [String]()
           var arrayOfArray = [Array<String>]()
        for i in 0 ..< arrkeys.count {

            let obj = arrkeys[i] as getkeysarr
            if obj.flag == true {
                let contact = JSON.init(parseJSON: dict[obj.keysv] as! String)

                   var myArray : [String] = []
                for obj in contact.arrayValue {
                    // arrobject.append(obj["dateofDay"])
                    myArray.append("\(obj["dateofDay"])")
                    count = true
                    //arroftimesheetdate.append("\(obj["dateofDay"])")
                    //append(obj["dateofDay"])
                }
                 arrayOfArray.append(myArray)
            }

        }

        print("arroftimesheetdate\(arrayOfArray)")
        for (index,obj) in arrayOfArray.enumerated() {
            print("indexofindex\(index)")
                arroftimefirstindex.append(obj[0])
        }

          print("arroftimefirstindex\(arroftimefirstindex)")

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
            //self.view.dodo.style.bar.hideAfterDelaySeconds = 10
            self.view.dodo.style.bar.hideOnTap = true

        } else {
            let refreshAlert = UIAlertController(title: "", message: "Do your really want to reject selected timesheet?", preferredStyle: UIAlertControllerStyle.actionSheet)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                let data = try? JSONSerialization.data(withJSONObject: arroftimefirstindex, options: [])
                let str = String(data:data!, encoding: String.Encoding.utf8)

                print("\(str!)")
                //        let weekstring = json(from : arrayOfArray)
                //        print("weekstring\(weekstring ?? "")")

                self.startMonitoringInternet()
                SwiftLoader.show(title: "Loading...", animated: true)
                let todosEndpoint: String = MAINURL + "ApproveEmployeeTimesheet"
                let newTodo: [String: Any] = ["userName": UserDefaults.standard.string(forKey: "username") ?? "","password": UserDefaults.standard.string(forKey: "password") ?? "","selectedEmployeeId":self.EmpID ?? "","selectedTimesheetWeekList":str ?? "" ,"timesheetAction": "Reject"]
                print("newtodo\(newTodo)")
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
                                        self.view.dodo.style.leftButton.onTap = { /* Button tapped */self.navigationController?.popViewController(animated: true) }

                                        // Close the bar when the button is tapped
                                        self.view.dodo.style.leftButton.hideOnTap = true
                                        self.view.dodo.topAnchor = self.view.safeAreaLayoutGuide.topAnchor
                                        self.view.dodo.success(contact)
                                        // self.view.dodo.style.bar.hideAfterDelaySeconds = 10
                                        self.view.dodo.style.bar.hideOnTap = true


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
                                    self.view.dodo.error(contact)
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
        //        var error:NSError?
        //        let joined = arroftimesheetdate.joined(separator: ", ")
        //        print(joined)
        //

    }
    func json(from object:Array<Any>) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
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

