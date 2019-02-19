//
//  PopupViewController.swift
//  iMobile
//
//  Created by Rahul Maurya on 23/03/18.
//  Copyright © 2018 Rahul Maurya. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {

    @IBOutlet weak var outsideview: UIView!
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        outsideview.layer.cornerRadius = 15
        outsideview.layer.shadowColor = UIColor.black.cgColor
        outsideview.layer.shadowOffset = CGSize(width: 0, height: 10)
        outsideview.layer.shadowOpacity = 0.9
        outsideview.layer.shadowRadius = 5
        let htmlFile = Bundle.main.path(forResource: "ColorLegend", ofType: "html")
        let html = try? String(contentsOfFile: htmlFile!, encoding: String.Encoding.utf8)
        webView.loadHTMLString(html!, baseURL: nil)

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
