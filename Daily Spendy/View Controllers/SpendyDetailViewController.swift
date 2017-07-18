//
//  SpendyDetailViewController.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/18/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import UIKit

class SpendyDetailViewController: UIViewController {

    // Constants
    
    // Properties
    var selected: Spendy?
    var selectedGroup = GroupRepo.shared.getByID("Ggeneral")!
    var money = 0
    
    let dropDown = DropDown()
    
    // Outlets
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtMoney: UITextField!
    @IBOutlet weak var txtGroup: UITextField!
    @IBOutlet weak var viewGroupTouch: UIView!
    
    // Actions
    @IBAction func negative(_ sender: Any) {
        money = -1 * money
    }
    
    @IBAction func back(_ sender: Any) {
        back()
    }
    
    @IBAction func save(_ sender: Any) {
        if txtName.text == "" {
            
        }
        else if txtMoney.text == "" {
            
        }
        else {
            if let selected = selected {
                selected.name = txtName.text!
                selected.money = Int16(money)
                selected.groupID = selectedGroup.id
                SpendyRepo.shared.update(spendy: selected)
            }
            else {
                SpendyRepo.shared.insert(name: txtName.text!, money: money, groupID: selectedGroup.id!)
            }
            
            back()
        }
    }
    
    @IBAction func showGroup(_ sender: Any) {
        self.performSegue(withIdentifier: "showGroup", sender: nil)
    }
    
    // Methods
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadData() {
        
    }
    
    func setupDropDown() {
        dropDown.anchorView = txtGroup
        dropDown.width = txtGroup.bounds.width
        dropDown.bottomOffset = CGPoint(x: 0, y: txtGroup.bounds.height)
        
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
        dropDown.maxHeight = dropDown.cellHeight * 3
        dropDown.selectionAction = { [unowned self] (index, item) in
            self.selectedGroup = GroupRepo.shared.list[index]
            self.txtGroup.text = self.selectedGroup.name
        }
        dropDown.dismissMode = .automatic
        dropDown.direction = .any
    }
    
    func reloadGroup() {
        GroupRepo.shared.loadData()
        let ds: [String] = GroupRepo.shared.list.map({$0.name!})
        dropDown.dataSource = ds
        dropDown.selectRow(at: 0)
    }
    
    func selectGroup() {
        dropDown.show()
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? GroupTableViewController {
            
        }
    }
    
    // View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtMoney.delegate = self
        
        if let _ = selected {
            self.title = "Sửa"
        }
        else {
            self.title = "Thêm"
        }
        
        setupDropDown()
        
        loadData()
        
        viewGroupTouch.isUserInteractionEnabled = true
        viewGroupTouch.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectGroup)))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadGroup()
    }
}

extension SpendyDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if txtMoney.text == "" {
            txtMoney.text = "0"
            money = 0
        }
        else {
            let plain = txtMoney.text!.replacingOccurrences(of: ",", with: "")
        }
        
        return true
    }
}
