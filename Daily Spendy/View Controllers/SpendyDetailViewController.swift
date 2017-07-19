//
//  SpendyDetailViewController.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/18/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SpendyDetailViewController: UIViewController {

    // Constants
    
    // Properties
    var selected: Spendy?
    var selectedGroup = GroupRepo.shared.getByID(GENERAL_GROUP_ID)!
    var money = 0
    var selectedDate: Date!
    
    let dropDownGroup = DropDown()
    
    // Outlets
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMoney: UITextField!
    @IBOutlet weak var txtGroup: UITextField!
    @IBOutlet weak var viewGroupTouch: UIView!
    @IBOutlet weak var timePicker: UIDatePicker!
    
    // Actions
    @IBAction func negative(_ sender: Any) {
        money = -1 * money
        txtMoney.text = money.toMoney("")
    }
    
    @IBAction func timePickerValueChanged(_ sender: Any) {
        selectedDate = timePicker.date
    }
    
    @IBAction func back(_ sender: Any) {
        back()
    }
    
    @IBAction func save(_ sender: Any) {
        self.view.endEditing(true)
        if txtName.text == "" {
            let alert = UIAlertController(title: "Lỗi", message: "Nội dung không được để trống!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Biết zòi", style: .default, handler: { _ in
                self.txtName.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else if txtMoney.text == "" || money == 0 {
            let alert = UIAlertController(title: "Lỗi", message: "Số tiền phải khác 0", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Biết zòi", style: .default, handler: { _ in
                self.txtMoney.becomeFirstResponder()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            if let selected = selected {
                selected.name = txtName.text!
                selected.money = Int64(money)
                selected.groupID = selectedGroup.id
                selected.date = selectedDate as NSDate
                SpendyRepo.shared.update(spendy: selected)
            }
            else {
                SpendyRepo.shared.insert(name: txtName.text!, money: money, groupID: selectedGroup.id!, date: selectedDate)
            }
            
            back()
        }
    }
    
    @IBAction func showGroup(_ sender: Any) {
        self.view.endEditing(true)
        self.performSegue(withIdentifier: "showGroup", sender: nil)
    }
    
    @IBAction func txtMoneyEditingChanged(_ sender: Any) {
        if txtMoney.text == "" {
            txtMoney.text = "0"
            money = 0
        }
        else {
            let plain = txtMoney.text!.replacingOccurrences(of: ",", with: "")
            if let num = Int(plain) {
                txtMoney.text = num.toMoney("")
                money = num
            } else {
                txtMoney.text = money.toMoney("")
            }
        }
    }
    
    // Methods
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        if let selected = selected {
            txtName.text = selected.name
            txtMoney.text = Int(selected.money).toMoney("")
            money = Int(selected.money)
            selectedDate = (selected.date! as Date)
            
            for i in 0 ..< GroupRepo.shared.list.count {
                if GroupRepo.shared.list[i].id == selected.groupID {
                    dropDownGroup.selectRow(at: i)
                    self.txtGroup.text = GroupRepo.shared.list[i].name
                    break
                }
            }
        }
        else {
            if selectedDate.startOfDate().isEqualDate(Date().startOfDate()) {
                selectedDate = Date(dateString: selectedDate.toString(withFormat: "ddMMyyyy") + Date().toString(withFormat: "HHmm"), format: "ddMMyyyyHHmm")
            }
            else {
                selectedDate = Date(dateString: selectedDate.toString(withFormat: "ddMMyyyy") + "0000", format: "ddMMyyyyHHmm")
            }
        }
        
        timePicker.date = selectedDate
    }
    
    func setupDropDown() {
        dropDownGroup.anchorView = txtGroup
        dropDownGroup.width = txtGroup.bounds.width
        dropDownGroup.bottomOffset = CGPoint(x: 0, y: txtGroup.bounds.height)
        
        DropDown.setupDefaultAppearance()
        let appearance = DropDown.appearance()
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadius = 10
        appearance.shadowColor = (0x68C9F8).toUIColor()
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 10
        appearance.animationduration = 0.25
        dropDownGroup.maxHeight = dropDownGroup.cellHeight * 3
        dropDownGroup.selectionAction = { [unowned self] (index, item) in
            self.selectedGroup = GroupRepo.shared.list[index]
            self.txtGroup.text = self.selectedGroup.name
        }
        dropDownGroup.dismissMode = .automatic
        dropDownGroup.direction = .any
    }
    
    func reloadGroup() {
        GroupRepo.shared.loadData()
        let ds: [String] = GroupRepo.shared.list.map({$0.name!})
        dropDownGroup.dataSource = ds
        dropDownGroup.selectRow(at: 0)
        self.txtGroup.text = GroupRepo.shared.list.first(where: { $0.id == GENERAL_GROUP_ID })!.name
    }
    
    func selectGroup() {
        self.view.endEditing(true)
        dropDownGroup.show()
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GroupTableViewController {
            
        }
    }
    
    // View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let _ = selected {
            self.title = "Sửa"
        }
        else {
            self.title = "Thêm"
        }
        
        setupDropDown()
        
        viewGroupTouch.isUserInteractionEnabled = true
        viewGroupTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectGroup)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadGroup()
        loadData()
    }
}
