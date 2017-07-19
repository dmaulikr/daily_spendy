//
//  CalendarCell.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/17/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import UIKit
import JTAppleCalendar

enum DateState: Int {
    case incoming = 0
    case outgoing = 1
    case both = 2
    case none = 3
}

class CalendarCell: JTAppleCell {

    // Properties
    var textColor: UIColor = .black {
        didSet {
            self.lblDate.textColor = textColor
        }
    }
    
    var state: DateState = .none {
        didSet {
            switch state {
            case .none:
                textColor = .black
                self.viewHighlight.backgroundColor = .clear
            case .outgoing:
                textColor = .white
                self.viewHighlight.backgroundColor = DATESTATE_OUTGOING_COLOR
            case .incoming:
                textColor = .white
                self.viewHighlight.backgroundColor = DATESTATE_INCOMING_COLOR
            case .both:
                textColor = .white
                self.viewHighlight.backgroundColor = DATESTATE_BOTH_COLOR
            }
        }
    }
    
    var date = Date()
    var isToday: Bool = false {
        didSet {
            self.lblDate.textColor = isToday ? .blue : textColor
        }
    }
    
    var start = 0
    var end = 0
    var incoming = 0
    var outgoing = 0
    
    // Outlets
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewHighlight: UIView!
    @IBOutlet weak var viewCurrent: UIView!
    @IBOutlet weak var imgvCurrent: UIImageView!
    
    // Methods 
    func calcMoney() {
        let spendies = SpendyRepo.shared.list.sorted(by: { ($0.0.date! as Date).isLessThanDate($0.1.date! as Date) })
        
        start = 0
        incoming = 0
        outgoing = 0
        for item in spendies {
            let itemDate = (item.date! as Date).startOfDate()
            if itemDate.isLessThanDate(date) {
                start += Int(item.money)
            }
            else if itemDate.isEqualDate(date) {
                if item.money > 0 {
                    incoming += Int(item.money)
                }
                else {
                    outgoing -= Int(item.money)
                }
            }
            else {
                break
            }
        }
        end = start - incoming - outgoing
        
        if incoming == 0 && outgoing == 0 {
            state = .none
        }
        else if incoming != 0 && outgoing != 0 {
            state = .both
        }
        else {
            if incoming != 0 {
                state = .incoming
            }
            else {
                state = .outgoing
            }
        }
    }
    
    // Cell
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        viewCurrent.clipsToBounds = false
//        viewCurrent.layer.borderColor = (0x68C9F8).toCGColor()
//        viewCurrent.layer.borderWidth = 1
//        viewCurrent.layer.cornerRadius = viewCurrent.bounds.width / 2
//        viewCurrent.layer.shadowColor = (0x68C9F8).toCGColor()
//        viewCurrent.layer.shadowOpacity = 1
//        viewCurrent.layer.shadowOffset = CGSize.zero
//        viewCurrent.layer.shadowRadius = 10
//        viewCurrent.layer.shadowPath = UIBezierPath(roundedRect: viewCurrent.bounds, cornerRadius: viewCurrent.bounds.width / 2).cgPath
        
        isToday = false
    }
}
