//
//  SpendyTableViewCell.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/18/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import UIKit

class SpendyTableViewCell: UITableViewCell {
    
    // Properties
    var spendy: Spendy!
    // Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMoney: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!

    // Methods
    func setData(_ spendy: Spendy) {
        lblName.text = spendy.name
        lblGroupName.text = GroupRepo.shared.getByID(spendy.groupID!)!.name
        lblTime.text = (spendy.date! as Date).toString(withFormat: "HH:mm")
        if spendy.money > 0 {
            lblMoney.textColor = .green
        }
        else {
            lblMoney.textColor = .red
        }
        
        lblMoney.text = Int(spendy.money).toMoney("")
    }
    
    // Cell
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
