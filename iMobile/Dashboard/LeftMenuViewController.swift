//
//  LeftMenuViewController.swift
//  SSASideMenuExample
//
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//

import Foundation
import UIKit
import EFInternetIndicator
import Alamofire
class LeftMenuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,InternetStatusIndicable {
    var internetConnectionIndicator: InternetViewIndicator?


    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lbluserID: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmailId: UILabel!
    var imageNames = ["home","fill_timesheet","apply_leave","leaveavailibility","leave_history"]
    var MenuNames = ["Home", "Fill Timesheet", "Apply Leave", "Leave Availabilty", "Leave History"]
    var managerarr = ["Employee Leave","Employee Timesheet"]
    var managerarrimg = ["employee_leave","employee_timesheet"]

    @IBOutlet weak var tblLeftMenu: UITableView!
    //    lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .none
//        tableView.frame = CGRect(x: 20, y: (self.view.frame.size.height - 54 * 5) / 2.0, width: self.view.frame.size.width, height: 54 * 5)
//        tableView.autoresizingMask = [.flexibleTopMargin, .flexibleBottomMargin, .flexibleWidth]
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        tableView.isOpaque = false
//        tableView.backgroundColor = UIColor.red
//        tableView.backgroundView = nil
//        tableView.bounces = false
//        return tableView
//    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        if UserDefaults.standard.value(forKey: "userType") as? String == "Supervisor" {
//             imageNames = ["home","fill_timesheet","apply_leave","leaveavailibility","leave_history","logout"]
//             MenuNames = ["Home", "Fill Timesheet", "Apply Leave", "Leave Availabilty", "Leave History", "Log out"]
//
//        }
//        else {
//             imageNames = ["home","fill_timesheet","apply_leave","leaveavailibility","leave_history","logout"]
//             MenuNames = ["Home", "Fill Timesheet", "Apply Leave", "Leave Availabilty", "Leave History", "Log out"]
//        }
        self.lblUsername.text = UserDefaults.standard.string(forKey: "EmployeeName")
        self.lbluserID.text = UserDefaults.standard.string(forKey: "username")
        self.lblEmailId.text = UserDefaults.standard.string(forKey: "EmployeeEmail")
        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
        self.profileImage.layer.masksToBounds = true
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.layer.borderWidth = 2
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = UIColor.white
       // NotificationCenter.default.addObserver(self, selector: #selector(LeftMenuViewController.setImage), name: NSNotification.Name(rawValue: "setImageNotification"), object: nil)
        getProfilePic()
      //  registerCells()
       // view.backgroundColor = UIColor.clear
       // view.addSubview(tableView)
    //   SSASideMenu.SSAStatusBarStyle.t
        
    }

    func getProfilePic() {
        self.startMonitoringInternet()

        let todosEndpoint: String = MAINURL + "UserProfileImage"
        let newTodo: [String: Any] = ["userName": UserDefaults.standard.string(forKey: "username") ?? "","password": UserDefaults.standard.string(forKey: "password") ?? ""]
        Alamofire.request(todosEndpoint, method: .post, parameters: newTodo, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response)
                //to get status code
                if let status = response.response?.statusCode {
                    switch(status){
                    case 200:
                        print("example success")
                    default:
                        print("error with response status: \(status)")
                    }
                }
                //to get JSON return value
                if let result = response.result.value {
                    let json = result as! NSDictionary
                    if json["Result"] as? Bool == true {
                        if json["Image"] != nil {
                            let contact = json["Image"] as! String
                            let dataDecoded : Data = Data(base64Encoded: contact, options: .ignoreUnknownCharacters)!
                            let decodedimage = UIImage(data: dataDecoded)
                            UserDefaults.standard.set(dataDecoded, forKey: "profileImage")
                            print(decodedimage)

                            DispatchQueue.main.async {
                                self.profileImage.image = decodedimage

                            }

                            // if let decodedData = Data(base64Encoded: requestBodyData, options: .ignoreUnknownCharacters) {
                            //                                let image = UIImage(data: decodedData)
                            //                                self.profileImage.image = image
                            //                                UserDefaults.standard.set(image, forKey: "profile_imaage")
                            //}
                            //  let img = UIImage(data: requestBodyData as Data)


                        }
                    }
                }

        }
    }

    func registerCells() {
       tblLeftMenu.register(UITableViewCell.self, forCellReuseIdentifier: "LeftmenuTableViewCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
             return "Manager"
        }
        return nil

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        } else if section == 1 {
            if UserDefaults.standard.value(forKey: "userType") as? String == "Supervisor"{
                return 30
            }
            else{
                return 0
            }
        } else if section == 2 {
             if UserDefaults.standard.value(forKey: "userType") as? String == "Supervisor" {
                return 5
            }
            else{
                return 0
            }
        }

        return 0
    }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if section == 0 {
                 return MenuNames.count
            } else if section == 1 {
                if UserDefaults.standard.value(forKey: "userType") as? String == "Supervisor" {
                    return managerarr.count
                }
                else{
                    return 0
                }
            }
            else if section == 2 {
                return 1
            } else {
                return 0
            }

        }



        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 62
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftmenuTableViewCell") as! LeftmenuTableViewCell?
            if indexPath.section == 0 {
                cell?.menuname.text = MenuNames[indexPath.row]
                cell?.menuImage.image = UIImage(named : imageNames[indexPath.row])
                //cell?.menuImage.tintColor = UIColor(red: 0, green: 122/255, blue: 255, alpha: 1.0)
              //  cell?.menuImage.image? = (cell?.menuImage.image?.maskWithColor(color: UIColor(red: 0, green: 122/255, blue: 255, alpha: 1.0)))!
               cell?.menuImage.image? = (cell?.menuImage.image?.maskWithColor(color: UIColor(red: 132/255, green: 60/255, blue: 12/255, alpha: 1.0)))!


            } else if indexPath.section == 1 {
                cell?.menuname.text = managerarr[indexPath.row]
                cell?.menuImage.image = UIImage(named : managerarrimg[indexPath.row])
                //cell?.menuImage.tintColor = UIColor(red: 0, green: 122/255, blue: 255, alpha: 1.0)
                cell?.menuImage.image? = (cell?.menuImage.image?.maskWithColor(color: UIColor(red: 132/255, green: 60/255, blue: 12/255, alpha: 1.0)))!
            } else {
                cell?.menuname.text = "Logout"
                cell?.menuImage.image = UIImage(named : "logout")
                //cell?.menuImage.tintColor = UIColor(red: 0, green: 122/255, blue: 255, alpha: 1.0)
                cell?.menuImage.image? = (cell?.menuImage.image?.maskWithColor(color: UIColor(red: 132/255, green: 60/255, blue: 12/255, alpha: 1.0)))!
            }


            return cell!
        }

        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            tableView.deselectRow(at: indexPath, animated: true)

            switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    sideMenuViewController?.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "DashboardViewController")

                    // sideMenuViewController?.contentViewController = NavigationvViewController(rootViewController: DashboardViewController())
                    sideMenuViewController?.hideMenuViewController()
                    
                } else if indexPath.row == 1 {
                    sideMenuViewController?.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "TimeSheetViewController")
                    //            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: SecondViewController())
                    sideMenuViewController?.hideMenuViewController()

                }else if indexPath.row == 2 {
                    sideMenuViewController?.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "DemoViewController")
                    sideMenuViewController?.hideMenuViewController()

                }else if indexPath.row == 3 {
                    sideMenuViewController?.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "LeaveAvailabilityViewController")
                    sideMenuViewController?.hideMenuViewController()
                }else {
                    sideMenuViewController?.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "LeaveHistoryViewController")
                    sideMenuViewController?.hideMenuViewController()
                }

                break
            case 1:
                if indexPath.row == 0 {
                    sideMenuViewController?.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeLeaveViewController")
                    //            sideMenuViewController?.contentViewController = UINavigationController(rootViewController: SecondViewController())
                    sideMenuViewController?.hideMenuViewController()

                }else if indexPath.row == 1 {
                    sideMenuViewController?.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "EmployeeTimesheetViewController")
                    sideMenuViewController?.hideMenuViewController()
                    
                }
                break
            case 2:
                //sideMenuViewController?.contentViewController = NavigationvViewController(rootViewController: DemoViewController())
                UserDefaults.standard.set("false", forKey: "LoginStatus")
                UserDefaults.standard.set("", forKey: "username")
                UserDefaults.standard.set("", forKey: "password")
                UserDefaults.standard.set("", forKey: "userType")
                UserDefaults.standard.set("", forKey: "EmployeeName")
                UserDefaults.standard.set("", forKey: "EmployeeEmail")
                UserDefaults.standard.set("", forKey: "EmployeeLocation")
                let storyboardChat = UIStoryboard(name: "Login", bundle: Bundle.main)
                let controller = storyboardChat.instantiateInitialViewController()
                let application = UIApplication.shared
                if let window = application.keyWindow {
                    window.rootViewController = controller
                }


                break

            default:
                break
            }


        }

    


}
// MARK : TableViewDataSource & Delegate Methods
extension UIImage {

    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!

        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!

        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)

        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}

    
