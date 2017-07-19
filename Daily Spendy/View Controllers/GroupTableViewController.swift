//
//  GroupTableViewController.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/18/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import UIKit

class GroupTableViewController: UITableViewController {

    // Constants
    
    // Properties
    var selected: Group?
    
    // Outlets
    
    // Actions
    @IBAction func add(_ sender: Any) {
        let alert = UIAlertController(title: "Thêm", message: "Nhập vào tên nhóm", preferredStyle: .alert)
        alert.addTextField { (txt) in
            txt.placeholder = "Tên nhóm"
        }
        
        let cancelAction = UIAlertAction(title: "Quay lại", style: .cancel) { (_) in
            
        }
        
        let doneAction = UIAlertAction(title: "Xong", style: .default) { (_) in
            if let txt = alert.textFields?.first, let name = txt.text, name != "" {
                GroupRepo.shared.insert(name: name)
                self.tableView.reloadData()
            }
            else {
                let alert2 = UIAlertController(title: "Lỗi", message: "Tên nhóm không được để trống!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Xong", style: .default) { (_) in
                    alert2.dismiss(animated: true, completion: nil)
                }
                alert2.addAction(okAction)
                self.present(alert2, animated: true, completion: nil)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func back(_ sender: Any) {
        back()
    }
    
    // Methods
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func edit(group: Group) {
        let alert = UIAlertController(title: "Sửa", message: "Nhập vào tên nhóm", preferredStyle: .alert)
        alert.addTextField { (txt) in
            txt.placeholder = "Tên nhóm"
            txt.text = group.name
        }
        
        let cancelAction = UIAlertAction(title: "Quay lại", style: .cancel) { (_) in
            
        }
        
        let doneAction = UIAlertAction(title: "Xong", style: .default) { (_) in
            if let txt = alert.textFields?.first, let name = txt.text, name != "" {
                group.name = name
                GroupRepo.shared.update(group: group)
                self.tableView.reloadData()
            }
            else {
                let alert2 = UIAlertController(title: "Lỗi", message: "Tên nhóm không được để trống!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Biết zòi", style: .default) { (_) in
                    alert2.dismiss(animated: true, completion: nil)
                }
                alert2.addAction(okAction)
                self.present(alert2, animated: true, completion: nil)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(doneAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func delete(group: Group) {
        if group.id == GENERAL_GROUP_ID {
            let alert = UIAlertController(title: "Lỗi", message: "Không được xóa nhóm \"Chung\"!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Biết zòi", style: .default) { (_) in
                self.tableView.setEditing(false, animated: true)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Xóa", message: "Bạn muốn xóa nhóm \"\(group.name!)\"?\n Các chi tiêu thuộc nhóm này sẽ chuyển vào nhóm \"Chung\"", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Quay lại", style: .cancel) { (_) in
                self.tableView.setEditing(false, animated: true)
            }
            
            let doneAction = UIAlertAction(title: "Xóa", style: .destructive) { (_) in
                GroupRepo.shared.delete(group: group)
                self.tableView.reloadData()
            }
            
            alert.addAction(cancelAction)
            alert.addAction(doneAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Navigation
    
    // View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Table
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if GroupRepo.shared.list.count == 0 {
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
        return GroupRepo.shared.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath)
        cell.textLabel?.text = GroupRepo.shared.list[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        edit(group: GroupRepo.shared.list[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Xóa") { (action, indexPath) in
            self.delete(group: GroupRepo.shared.list[indexPath.row])
        }
        
        return [deleteAction]
    }
}
