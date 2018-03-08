//
//  Opportunity.swift
//  helloworld-ios-app
//
//  Created by Marco Metting on 08.03.18.
//  Copyright © 2018 FeedHenry. All rights reserved.
//

import UIKit

class Opportunity: NSObject {
    
    var id: String
    var name: String
    var dealSize: String
    var unformattedSize : Float
    var status: String
    var subscribed: Bool
    
    override init() {
        self.id = ""
        self.name = ""
        self.dealSize = "0.00 €"
        self.unformattedSize = 0
        self.status = ""
        self.subscribed = false
    }
    
    convenience init(data: [String : Any]) {
        
        self.init()
        
        let subscribed = data["subscribed"] as! Bool
        
        self.prepare(id: data["id"] as! String,
                     name: data["name"] as! String,
                     dealSize: data["dealSize"] as! Float,
                     status: data["status"] as! String,
                     subscribed: subscribed)
    }
    
    
    func prepare(id:String, name:String, dealSize:Float, status:String, subscribed:Bool) {
        
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        self.unformattedSize = dealSize
        
        if let formattedAmount = formatter.string(from: NSNumber.init(value: dealSize)) {
            self.dealSize = formattedAmount
        }
        
        self.id = id
        self.name = name
        self.status = status
        self.subscribed = subscribed
    }
    
    func toJson() -> String {
        
        var json = "{"
        
        json = json + "id : " + self.id + ","
        json = json + "name : " + self.name + ","
        json = json + "dealSize : \(self.unformattedSize)" + ","
        json = json + "status : " + self.status + ","
        
        if (self.subscribed) {
            json = json + "subscibed : true"
        } else {
            json = json + "subscibed : false"
        }

        json = json + "}"
        
        return json
    }
}
