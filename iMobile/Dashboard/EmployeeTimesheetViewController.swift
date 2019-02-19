//
//  EmployeeTimesheetViewController.swift
//  iMobile
//
//  Created by Rahul Maurya on 27/03/18.
//  Copyright © 2018 Rahul Maurya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftLoader
import EFInternetIndicator
import Foundation

class EmployeeTimesheetViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,InternetStatusIndicable {
    @IBOutlet weak var btnnext: UIButton!
    @IBOutlet weak var btnPrev: UIButton!
    
    var intialcount : String?
    var internetConnectionIndicator: InternetViewIndicator?
    var contact : NSDictionary = [:]
    @IBOutlet weak var lblPageindex: UILabel!
    @IBOutlet weak var tblEmptimesheet: UITableView!
    var arrKeys = [getkeysTimesheet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        intialcount = "0"
        self.title = "Employee Timesheet"
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
        //getBulkEMpTimesheet()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        arrKeys.removeAll()
        getBulkEMpTimesheet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getBulkEMpTimesheet() {
        self.startMonitoringInternet()
        SwiftLoader.show(title: "Loading...", animated: true)
        let todosEndpoint: String = MAINURL + "BulkEmployeeTimesheets"
        let newTodo: [String: Any] = ["userName": UserDefaults.standard.string(forKey: "username") ?? "","password": UserDefaults.standard.string(forKey: "password") ?? "","initialCount": intialcount ?? "0"]
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

                        if json["EmployeesTimesheet"] != nil{
                            DispatchQueue.main.async {
                                self.contact = json["EmployeesTimesheet"] as! NSDictionary

                                let keys = self.contact.flatMap(){ $0.0 as? String }
                                let sortedArray = keys.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
                                print(result)
                                print(self.contact )
                                print(sortedArray)
                                var arr : [Any]?
                                for obj in sortedArray
                                {

                                     arr = obj.components(separatedBy: "|")
                                    let newItem = getkeysTimesheet()
                                    newItem.name = "\(arr?.last ?? "")"
                                    newItem.id = "\(arr?.first ?? "")"
                                    self.arrKeys.append(newItem)

                                }
                                self.lblPageindex.text = "\(self.arrKeys.count)/\(json["Totalemployees"] ?? "")"
                                let total = (Int(self.intialcount!)!/10)+1
                                let nsnumtoint = Int(json["Totalemployees"] as! NSNumber)
                    
                                if nsnumtoint <= 10 {
                                    self.btnnext.isEnabled = false
                                     self.btnPrev.isEnabled = false
                                } else if Int(self.intialcount!)! + 10 >= nsnumtoint {
                                    //prev true
                                    self.btnnext.isEnabled = false
                                    self.btnPrev.isEnabled = true
                                } else if Int(self.intialcount!)! <= 0 {
                                    //next true
                                    self.btnnext.isEnabled = true
                                    self.btnPrev.isEnabled = false
                                } else
                                {
                                    self.btnnext.isEnabled = true
                                    self.btnPrev.isEnabled = true
                                }

                                let val = Int(ceil(json["Totalemployees"] as? NSNumber as! Double)) / 10 + 1
                                self.lblPageindex.text = "page:\(total)/\(val)"

                                self.tblEmptimesheet.reloadData()


                 //               for obj in contact.arrayValue{
//                                    let newItem = getLeaveshistorymodel()
//                                    newItem.dayType = "\(obj["dayType"])"
//                                    newItem.Leavedates = "\(obj["Leavedates"])"
//                                    newItem.statusChangeTime = "\(obj["statusChangeTime"])"
//                                    newItem.status = "\(obj["status"])"
//                                    newItem.leaveReqBy = "\(obj["leaveReqBy"])"
//                                    newItem.comment = "\(obj["comment"])"
//                                    newItem.leaveReqTime = "\(obj["leaveReqTime"])"
//                                    newItem.statusChangeBy = "\(obj["statusChangeBy"])"
//                                    newItem.totalLeaves = "\(obj["totalLeaves"])"
//                                    newItem.leavetype = "\(obj["leavetype"])"
//                                    newItem.leaveReqId = "\(obj["leaveReqId"])"
//                                    self.arrLeaves.append(newItem);
                               // }

                               // self.tblHistory.reloadData()
                            }
                        }
                    }


                }

        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrKeys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell : EmpTImesheetTableViewCell = tableView.dequeueReusableCell(withIdentifier: "EmpTImesheetTableViewCell" , for:indexPath) as! EmpTImesheetTableViewCell
        let obj = arrKeys[indexPath.row] as getkeysTimesheet
        cell.lblName.text = obj.name.capitalized
        cell.lblID.text = obj.id
        let str = "\(obj.id)|\(obj.name)"
        let arr = contact[str] as! NSDictionary

        if arr.count != 0 {
            for i in 0 ..< arr.allKeys.count {
                var hours : String?
                let key = arr.allKeys[i] as! String
                let real =  key.components(separatedBy: "|").last//?.components(separatedBy: "|").last
                if key[11 ..< 13].length == 2 {

                     hours =  key[11 ..< 13].onlyDigits
                } else {
                    var value = key[11]
                    let truncated = value.remove(at: value.index(before: value.endIndex))
                    hours = "\(truncated)"
                }

                print("real-\(real ?? "")")
                print("hours-\(hours ?? "")")
                if i == 0 {
                    cell.firstlbl.text = hours
                }
                if i == 1 {
                    cell.seclbl.text = hours
                }
                if i == 2 {
                    cell.thirdlbl.text = hours
                }
                if i == 3 {
                    cell.forthlbl.text = hours
                }
                if i == 4 {
                    cell.fifthlbl.text = hours
                }
                //let hour = key.components(separatedBy: "|").
                if real == "Approved" {
                    if i == 0 {
                        cell.firstlbl.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
                    }
                    if i == 1 {
                        cell.seclbl.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
                    }
                    if i == 2 {
                        cell.thirdlbl.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
                    }
                    if i == 3 {
                        cell.forthlbl.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
                    }
                    if i == 4 {
                        cell.fifthlbl.backgroundColor = UIColor(rgb: 0x7cf15e, alphaVal: 1)
                    }
                }
                if real == "Rejected" {
                    if i == 0 {
                        cell.firstlbl.backgroundColor = UIColor(rgb: 0xfc5b5b, alphaVal: 1)
                    }
                    if i == 1 {
                        cell.seclbl.backgroundColor = UIColor(rgb: 0xfc5b5b, alphaVal: 1)
                    }
                    if i == 2 {
                        cell.thirdlbl.backgroundColor = UIColor(rgb: 0xfc5b5b, alphaVal: 1)
                    }
                    if i == 3 {
                        cell.forthlbl.backgroundColor = UIColor(rgb: 0xfc5b5b, alphaVal: 1)
                    }
                    if i == 4 {
                        cell.fifthlbl.backgroundColor = UIColor(rgb: 0xfc5b5b, alphaVal: 1)
                    }
                }


            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = arrKeys[indexPath.row] as getkeysTimesheet
        let str = "\(obj.id)|\(obj.name)"
        let arr = contact[str] as! NSDictionary

        if arr.count != 0 {
            let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeTimesheetDetailsViewController") as! EmployeeTimesheetDetailsViewController
            secondViewController.dict = arr
            secondViewController.EmpID = "\(obj.id)"
            self.navigationController?.pushViewController(secondViewController, animated: true)
        } else {
            view.dodo.style.leftButton.icon = .close

            // Supply your image
            view.dodo.style.leftButton.image = UIImage(named: "CloseIcon")

            // Change button's image color
            view.dodo.style.leftButton.tintColor = UIColor.white

            // Do something on tap
            view.dodo.style.leftButton.onTap = { /* Button tapped */ }

            // Close the bar when the button is tapped
            view.dodo.style.leftButton.hideOnTap = true
            view.dodo.topAnchor = view.safeAreaLayoutGuide.topAnchor
            view.dodo.error("Employee Timesheet Empty")
            view.dodo.style.bar.hideAfterDelaySeconds = 10
            view.dodo.style.bar.hideOnTap = true
        }

        print(arr)

//        for obj in arr.allValues {
//              print(obj)
//        }
    }


    @IBAction func btnNextAction(_ sender: Any) {

        arrKeys.removeAll()
        let intvvalue = Int("\(intialcount ?? "0")")! + 10
        intialcount = "\(intvvalue)"
        getBulkEMpTimesheet()

    }

    @IBAction func btnprevAction(_ sender: Any) {
        arrKeys.removeAll()
        let intvvalue = Int("\(intialcount ?? "0")")! - 10
        intialcount = "\(intvvalue)"
        getBulkEMpTimesheet()
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

extension String {

    var length: Int {
        return self.characters.count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    private func removeCharacters(unicodeScalarsFilter: (UnicodeScalar) -> Bool) -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{unicodeScalarsFilter($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }

    private func removeCharacters(from charSets: [CharacterSet], unicodeScalarsFilter: (CharacterSet, UnicodeScalar) -> Bool) -> String {
        return removeCharacters{ unicodeScalar in
            for charSet in charSets {
                let result = unicodeScalarsFilter(charSet, unicodeScalar)
                if result {
                    return true
                }
            }
            return false
        }
    }

    func removeCharacters(charSets: [CharacterSet]) -> String {
        return removeCharacters(from: charSets) { charSet, unicodeScalar in
            !charSet.contains(unicodeScalar)
        }
    }

    func removeCharacters(charSet: CharacterSet) -> String {
        return removeCharacters(charSets: [charSet])
    }

    func onlyCharacters(charSets: [CharacterSet]) -> String {
        return removeCharacters(from: charSets) { charSet, unicodeScalar in
            charSet.contains(unicodeScalar)
        }
    }

    func onlyCharacters(charSet: CharacterSet) -> String {
        return onlyCharacters(charSets: [charSet])
    }
    var onlyDigits: String {
        return onlyCharacters(charSets: [.decimalDigits])
    }

}

