//
//  LoginViewController.swift
//  iMobile
//
//  Created by Rahul Maurya on 13/03/18.
//  Copyright © 2018 Rahul Maurya. All rights reserved.
//

import UIKit
import MaterialActivityIndicator
import EFInternetIndicator
import JVFloatLabeledTextField
import Alamofire
class LoginViewController: UIViewController,InternetStatusIndicable {
    var internetConnectionIndicator: InternetViewIndicator?

    @IBOutlet weak var txtUserId: JVFloatLabeledTextField!

    @IBOutlet weak var txtPassword: JVFloatLabeledTextField!
    private let indicator = MaterialActivityIndicatorView()
    @IBOutlet weak var btnlogin: UIButton! {
        didSet {
            btnlogin.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
            btnlogin.layer.cornerRadius = 8.0
             btnlogin.clipsToBounds = true
        }
    }

    @IBOutlet weak var btnCheckUnchek: UIButton! {
        didSet {
            btnCheckUnchek.layer.cornerRadius = 4.0
            btnCheckUnchek.clipsToBounds = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         setupActivityIndicatorView()
        btnCheckUnchek.tag = 1
        //indicator.startAnimating()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    @IBAction func btnLoginAction(_ sender: Any) {
        animateButton()
        self.startMonitoringInternet()
        if txtUserId.text == "" {
            view.dodo.topAnchor = view.safeAreaLayoutGuide.topAnchor
            view.dodo.error("Please Enter Username")
            view.dodo.style.bar.hideAfterDelaySeconds = 10
            view.dodo.style.bar.hideOnTap = true
        } else if txtPassword.text == "" {
            view.dodo.topAnchor = view.safeAreaLayoutGuide.topAnchor
            view.dodo.error("Please Enter Password")
            view.dodo.style.bar.hideAfterDelaySeconds = 10
            view.dodo.style.bar.hideOnTap = true
        } else {
            indicator.startAnimating()
            let todosEndpoint: String = "https://exnovations-pun.intelizi.com/rest/ExnovationRestWebService/LoginValidation"
            let newTodo: [String: Any] = ["userName": self.txtUserId.text ?? "", "password": self.txtPassword.text ?? ""]
            Alamofire.request(todosEndpoint, method: .post, parameters: newTodo,
                              encoding: JSONEncoding.default)
                .responseJSON { response in
                    self.indicator.stopAnimating()
                    guard response.result.error == nil else {
                        // got an error in getting the data, need to handle it
                        print("error calling POST on /todos/1")
                        print(response.result.error!)
                        return
                    }
                    // make sure we got some JSON since that's what we expect
                    guard let json = response.result.value as? [String: Any] else {
                        print("didn't get todo object as JSON from API")
                        print("Error: \(response.result.error)")
                        return
                    }
                    // get and print the title
                    //                guard let todoTitle = json["title"] as? String else {
                    //                    print("Could not get todo title from JSON")
                    //                    return
                    //                }
                    print("json print\(json)")
                    if  json["Result"] as? Bool == true{
                        if self.btnCheckUnchek.tag == 0 {
                            UserDefaults.standard.set("true", forKey: "LoginStatus")
                        } else {
                            UserDefaults.standard.set("false", forKey: "LoginStatus")
                        }


                            UserDefaults.standard.set(self.txtUserId.text, forKey: "username")
                            UserDefaults.standard.set(self.txtPassword.text, forKey: "password")
                        if let val = json["userType"] as? String {
                            if val.range(of:"Supervisor") != nil {
                                UserDefaults.standard.set("Supervisor", forKey: "userType")
                            }
                            else {
                                UserDefaults.standard.set(val, forKey: "userType")
                            }

                        }
                        if let val = json["EmployeeName"] as? String {
                            UserDefaults.standard.set(val, forKey: "EmployeeName")
                        }
                        if let val = json["employeeType"] as? String {
                            UserDefaults.standard.set(val, forKey: "employeeType")
                        }
                        if let val = json["EmployeeEmail"] as? String {
                            UserDefaults.standard.set(val, forKey: "EmployeeEmail")
                        }
                        if let val = json["EmployeeLocation"] as? String {
                            UserDefaults.standard.set(val, forKey: "EmployeeLocation")
//                            if val == "Pune" {
//                               MAINURL = "https://intranet-pun.intelizi.com/rest/ExnovationRestWebService/"
//                            }
//                            if val == "Chennai" {
//                                MAINURL = "https://intranet-chn.intelizi.com/rest/ExnovationRestWebService/"
//                            }
//                            if val == "Bangalore" {
//                                MAINURL = "https://intranet-bgl.intelizi.com/rest/ExnovationRestWebService/"
//                            }
                        }
                        self.openDashboard()

                    }
                    else {
                        self.view.dodo.topAnchor = self.view.safeAreaLayoutGuide.topAnchor
                        self.view.dodo.error("\(json["Response"] ?? "failed")")
                        self.view.dodo.style.bar.hideAfterDelaySeconds = 10
                        self.view.dodo.style.bar.hideOnTap = true
                        print("failed\(json["Response"] ?? "failed")")
                    }

            }

        }

    }
    func openDashboard() {
        let storyboardChat = UIStoryboard(name: "Dashboard", bundle: Bundle.main)
        let controller = storyboardChat.instantiateInitialViewController()
        let application = UIApplication.shared
        if let window = application.keyWindow {
            window.rootViewController = controller
        }
    }

    @IBAction func btncheckUnchekAction(_ sender: Any) {
        if btnCheckUnchek.tag == 0 {
        btnCheckUnchek.setBackgroundImage(UIImage(named: "square-outline-64"), for: UIControlState.normal)
            btnCheckUnchek.tag = 1
        } else {
        btnCheckUnchek.setBackgroundImage(UIImage(named: "check-mark-8-64"), for: UIControlState.normal)
            btnCheckUnchek.tag = 0
        }
    }


    func animateButton() {
        UIView.animate(withDuration: 0.6,
                       animations: {
                        self.btnlogin.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
                        UIView.animate(withDuration: 0.6) {
                            self.btnlogin.transform = CGAffineTransform.identity
                        }
        })
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

extension LoginViewController {
    private func setupActivityIndicatorView() {
        view.addSubview(indicator)
        setupActivityIndicatorViewConstraints()
    }

    private func setupActivityIndicatorViewConstraints() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
       // indicator.backgroundColor = UIColor.lightGray
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

