//
//  SelectYearTableViewController.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/18/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import UIKit

class SelectYearTableViewController: UITableViewController {

    // Constants
    
    // Properties
    var mainVC: MainViewController!
    
    var dataSource = [Int]()
    
    var selectedYear = 0
    
    // Outlets
    
    // Actions
    @IBAction func back(_ sender: Any) {
        back()
    }
    
    @IBAction func ok(_ sender: Any) {
        mainVC.scrollTo(month: mainVC.selectedMonth, year: selectedYear)
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
        
        dataSource.removeAll()
        for i in selectedYear-10...selectedYear+10 {
            dataSource.append(i)
        }
    }
    
    // Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "yearCell", for: indexPath)
        cell.textLabel?.text = "\(dataSource[indexPath.row])"
        cell.accessoryType = .none
        if dataSource[indexPath.row] == selectedYear {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedYear = dataSource[indexPath.row]
        tableView.reloadData()
    }

}
