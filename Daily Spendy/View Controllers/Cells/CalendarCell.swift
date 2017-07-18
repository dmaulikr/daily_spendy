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
                self.viewHighlight.backgroundColor = .red
            case .incoming:
                textColor = .white
                self.viewHighlight.backgroundColor = .green
            case .both:
                textColor = .white
                self.viewHighlight.backgroundColor = .orange
            }
        }
    }
    
    var date = Date()
    var isToday: Bool = false {
        didSet {
            self.lblDate.textColor = isToday ? .blue : textColor
        }
    }
    
    // Outlets
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewHighlight: UIView!
    @IBOutlet weak var viewCurrent: UIView!
    
    // Cell
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewCurrent.layer.borderColor = UIColor.blue.cgColor
        viewCurrent.layer.borderWidth = 2
        viewCurrent.layer.cornerRadius = viewCurrent.bounds.width / 2
        viewCurrent.backgroundColor = .clear
        
        isToday = false
    }
}
