//
//  ViewController.swift
//  iMobile
//
//  Created by Rahul Maurya on 13/03/18.
//  Copyright © 2018 Rahul Maurya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var image1Outlet: UIImageView!
    
    @IBOutlet weak var image2outlet: UIImageView!
    @IBOutlet weak var firstLogoconstrainsts: NSLayoutConstraint! {
        didSet {
            firstLogoconstrainsts.constant = 0
        }
    }

    @IBOutlet weak var secondbottomConstrsints: NSLayoutConstraint! {
        didSet {
            secondbottomConstrsints.constant = 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let centerYConstraint = NSLayoutConstraint(item: self.image1Outlet,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: self.view,
                                                   attribute: .top,
                                                   multiplier: 1,
                                                   constant: 0)
        let centerYConstraint2 = NSLayoutConstraint(item: self.image2outlet,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: self.view,
                                                   attribute: .bottom,
                                                   multiplier: 1,
                                                   constant: 0)
        self.firstLogoconstrainsts.constant = (self.view.frame.size.height / 2) - 180
        self.secondbottomConstrsints.constant = self.view.frame.size.height / 2 - 180
        UIView.animate(withDuration: 1) {
            self.view.layoutIfNeeded()
             Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.splashTimeOut(sender:)), userInfo: nil, repeats: false)

        }


    }
    @objc func splashTimeOut(sender : Timer){
        if (UserDefaults.standard.value(forKey: "LoginStatus") != nil) {
            if UserDefaults.standard.value(forKey: "LoginStatus") as! String == "true" {
                let storyboardChat = UIStoryboard(name: "Dashboard", bundle: Bundle.main)
                let controller = storyboardChat.instantiateInitialViewController()
                let application = UIApplication.shared
                if let window = application.keyWindow {
                    window.rootViewController = controller
                }
            }
            else {
                let storyboardChat = UIStoryboard(name: "Login", bundle: Bundle.main)
                let controller = storyboardChat.instantiateInitialViewController()
                let application = UIApplication.shared
                if let window = application.keyWindow {
                    window.rootViewController = controller
                }
            }


        } else {
            let storyboardChat = UIStoryboard(name: "Login", bundle: Bundle.main)
            let controller = storyboardChat.instantiateInitialViewController()
            let application = UIApplication.shared
            if let window = application.keyWindow {
                window.rootViewController = controller
            }

        }


    }
    func sharedInstance() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

