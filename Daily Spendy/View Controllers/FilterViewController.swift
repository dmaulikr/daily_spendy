//
//  FilterViewController.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/19/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    // Constants
    
    // Properties
    let dateFormat = "dd / MM / yyyy"
    
    // Outlets
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var viewFrom: UIView!
    @IBOutlet weak var txtTo: UITextField!
    @IBOutlet weak var viewTo: UIView!
    
    // Actions
    @IBAction func search(_ sender: Any) {
        performSegue(withIdentifier: "report", sender: self)
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // Methods
    func viewFromTapped() {
        let dtp = DatePickerDialog()
        let defaultDate = Date(dateString: txtFrom.text ?? "", format: dateFormat)
        dtp.show(title: "Từ ngày", doneButtonTitle: "OK", cancelButtonTitle: "Quay lại", defaultDate: defaultDate, minimumDate: nil, maximumDate: nil, datePickerMode: .date) { (selected) in
            if let selected = selected {
                self.txtFrom.text = selected.toString(withFormat: self.dateFormat)
            }
        }
    }
    
    func viewToTapped() {
        let dtp = DatePickerDialog()
        let defaultDate = Date(dateString: txtTo.text ?? "", format: dateFormat)
        let minDate = Date(dateString: txtFrom.text ?? "", format: dateFormat)
        dtp.show(title: "Đến ngày", doneButtonTitle: "OK", cancelButtonTitle: "Quay lại", defaultDate: defaultDate, minimumDate: minDate, maximumDate: nil, datePickerMode: .date) { (selected) in
            if let selected = selected {
                self.txtTo.text = selected.toString(withFormat: self.dateFormat)
            }
        }
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ReportViewController {
            vc.fromDate = Date(dateString: txtFrom.text ?? "", format: dateFormat).startOfDate()
            vc.toDate = Date(dateString: txtTo.text ?? "", format: dateFormat).startOfDate()
        }
    }
    
    // View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewFrom.isUserInteractionEnabled = true
        viewFrom.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewFromTapped)))
        
        viewTo.isUserInteractionEnabled = true
        viewTo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewToTapped)))
        
        txtFrom.text = Date().addDays(-30).toString(withFormat: dateFormat)
        txtTo.text = Date().toString(withFormat: dateFormat)
    }

}
