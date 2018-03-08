//
//  OpportunityCellTableViewCell.swift
//  helloworld-ios-app
//
//  Created by Marco Metting on 08.03.18.
//  Copyright © 2018 FeedHenry. All rights reserved.
//

import UIKit

class OpportunityCellTableViewCell: UITableViewCell {

    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var name: UILabel!
    
    func configureCell(_ opportunity:Opportunity) {
        self.id.text = opportunity.id;
        self.name.text = opportunity.name;
    }

}
