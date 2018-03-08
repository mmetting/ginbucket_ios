//
//  OpportunityDetailViewController.swift
//  helloworld-ios-app
//
//  Created by Marco Metting on 08.03.18.
//  Copyright © 2018 FeedHenry. All rights reserved.
//

import UIKit
import FeedHenry

class OpportunityDetailViewController: UIViewController {

    @IBOutlet weak var subscribeButton: UIButton!
    @IBOutlet weak var dealSize: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var name: UILabel!
    
    var opp : Opportunity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.dealSize.text = String(describing: self.opp.dealSize)
        self.name.text = self.opp.name
        self.status.text = self.opp.status
        
        if (self.opp.subscribed) {
            self.subscribeButton.isHidden = true
        } else {
            self.subscribeButton.isHidden = false
        }
    }
    
    @IBAction func subscribePressed(_ sender: Any) {
        
        let args = ["data": self.opp.toJson()] as [String : AnyObject]
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        FH.cloud(path: "opportunities/subscribe",
                 method: HTTPMethod.POST,
                 args: args,
                 completionHandler: {(resp: Response, error: NSError?) -> Void in
                    
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    
                    if error != nil {
                        print("Cloud Call Failed: " + (error?.localizedDescription)!)
                        return
                    }
                    print("Success")
                    
                    self.navigationController?.popViewController(animated: true)
        })
    }
}
