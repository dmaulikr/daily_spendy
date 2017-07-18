//
//  SelectMonthTableViewController.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/17/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import UIKit

class SelectMonthTableViewController: UITableViewController {

    // Constants
    
    // Properties
    var mainVC: MainViewController!
    
    let dataSource = [
        "Tháng Một",
        "Tháng Hai",
        "Tháng Ba",
        "Tháng Tư",
        "Tháng Năm",
        "Tháng Sáu",
        "Tháng Bảy",
        "Tháng Tám",
        "Tháng Chín",
        "Tháng Mười",
        "Tháng Mười Một",
        "Tháng Mười Hai"
    ]
    
    var selectedIndex = 0
    
    // Outlets
    
    // Actions
    @IBAction func back(_ sender: Any) {
        back()
    }
    
    @IBAction func ok(_ sender: Any) {
        mainVC.scrollTo(month: selectedIndex + 1, year: mainVC.selectedYear)
        back()
    }
    
    // Methods
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Navigation
    
    // View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "monthCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.accessoryType = .none
        if indexPath.row == selectedIndex {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
    }
}
