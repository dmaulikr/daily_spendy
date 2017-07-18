//
//  SpendyTableViewController.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/18/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import UIKit

class SpendyTableViewController: UITableViewController {

    // Constants
    let cellIdentifier = "spendyCell"
    let cellNibName = "SpendyTableViewCell"
    
    // Properties
    var selectedDate = Date()
    var selectedSpendy: Spendy?
    
    // Outlets
    
    // Actions
    @IBAction func back(_ sender: Any) {
    }
    
    // Methods
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add(_ sender: Any) {
        selectedSpendy = nil
        self.performSegue(withIdentifier: "edit", sender: nil)
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SpendyDetailViewController {
            vc.selected = self.selectedSpendy
        }
    }
    
    // View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.title = selectedDate.toString(withFormat: "dd/MM/yyyy")
    }

    // Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SpendyRepo.shared.list.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSpendy = SpendyRepo.shared.list[indexPath.row]
        self.performSegue(withIdentifier: "edit", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SpendyTableViewCell
        let spendy = SpendyRepo.shared.list[indexPath.row]
        cell.setData(spendy)
        return cell
    }
}
