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
    var dataSource = [Spendy]()
    
    // Outlets
    
    // Actions
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Methods
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func add(_ sender: Any) {
        selectedSpendy = nil
        self.performSegue(withIdentifier: "edit", sender: nil)
    }
    
    func delete(spendy: Spendy) {
        let alert = UIAlertController(title: "Xóa", message: "Bạn muốn xóa  \"\(spendy.name!)\"?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Quay lại", style: .cancel) { (_) in
            self.tableView.setEditing(false, animated: true)
        }
        
        let doneAction = UIAlertAction(title: "Xóa", style: .destructive) { (_) in
            SpendyRepo.shared.delete(spendy: spendy)
            self.tableView.reloadData()
        }
        
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SpendyDetailViewController {
            vc.selected = self.selectedSpendy
            vc.selectedDate = self.selectedDate
        }
    }
    
    // View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove odd rows
        tableView.tableFooterView = UIView()
        
        // register cell
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        // tableview row height systaltic
        tableView.estimatedRowHeight = 93
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = selectedDate.toString(withFormat: "dd/MM/yyyy")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataSource = SpendyRepo.shared.list.filter({ ($0.date! as Date).startOfDate().isEqualDate(self.selectedDate.startOfDate()) })
        tableView.reloadData()
    }

    // Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count == 0 {
            let view = UIView.loadFromNibNamed("NoDataView")!
            view.frame = tableView.frame
            view.tag = 999
            self.view.addSubview(view)
        }
        else {
            for v in self.view.subviews {
                if v.tag == 999 {
                    v.removeFromSuperview()
                }
            }
        }
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSpendy = dataSource[indexPath.row]
        self.performSegue(withIdentifier: "edit", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SpendyTableViewCell
        let spendy = dataSource[indexPath.row]
        cell.setData(spendy)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Xóa") { (action, indexPath) in
            self.delete(spendy: self.dataSource[indexPath.row])
        }
        
        return [deleteAction]
    }
}
