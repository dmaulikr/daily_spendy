//
//  ReportViewController.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/19/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import UIKit

class SpendySection {
    var index = 0
    var title = ""
    var spendies = [Spendy]()
}

class ReportViewController: UIViewController {

    // Constants
    let cellIdentifier = "spendyCell"
    let cellNibName = "SpendyTableViewCell"
    
    // Properties
    let dropDownGroup = DropDown()
    var selectedGroupIndex = -1
    let dropDownType = DropDown()
    var selectedTypeIndex = 0
    var fromDate = Date()
    var toDate = Date()
    var spendySections = [SpendySection]()
    
    var start = 0 {
        didSet {
            lblStartMoney.text = "\(start.toMoney(""))"
        }
    }
    
    var end = 0 {
        didSet {
            lblEndMoney.text = "\(end.toMoney(""))"
        }
    }
    
    var incoming = 0 {
        didSet {
            lblIncoming.text = "\(incoming.toMoney(""))"
        }
    }
    
    var outgoing = 0 {
        didSet {
            lblOutgoing.text = "\(outgoing.toMoney(""))"
        }
    }
    
    // Outlets
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var lblStartMoney: UILabel!
    @IBOutlet weak var lblEndMoney: UILabel!
    @IBOutlet weak var lblIncoming: UILabel!
    @IBOutlet weak var lblOutgoing: UILabel!
    @IBOutlet weak var txtGroup: UITextField!
    @IBOutlet weak var viewGroup: UIView!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var viewType: UIView!
    
    // Actions
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Methods
    func setupDropDown() {
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
        
        dropDownGroup.anchorView = txtGroup
        dropDownGroup.width = txtGroup.bounds.width
        dropDownGroup.bottomOffset = CGPoint(x: 0, y: txtGroup.bounds.height)
        dropDownGroup.maxHeight = dropDownGroup.cellHeight * 3
        GroupRepo.shared.loadData()
        var dsGroup: [String] = GroupRepo.shared.list.map({$0.name!})
        dsGroup.insert("Tất cả", at: 0)
        dropDownGroup.dataSource = dsGroup
        dropDownGroup.selectRow(at: 0)
        self.txtGroup.text = "Tất cả"
        dropDownGroup.selectionAction = { [unowned self] (index, item) in
            if index == 0 {
                self.selectedGroupIndex = -1
                self.txtGroup.text = "Tất cả"
            }
            else {
                self.selectedGroupIndex = index-1
                self.txtGroup.text = GroupRepo.shared.list[index-1].name
            }
            
            self.loadData(groupIndex: self.selectedGroupIndex, typeIndex: self.selectedTypeIndex)
        }
        dropDownGroup.dismissMode = .automatic
        dropDownGroup.direction = .any
        
        dropDownType.anchorView = txtType
        dropDownType.width = txtType.bounds.width
        dropDownType.bottomOffset = CGPoint(x: 0, y: txtType.bounds.height)
        dropDownType.maxHeight = dropDownType.cellHeight * 3
        var dsType: [String] = ["Thu & Chi", "Thu", "Chi"]
        dropDownType.dataSource = dsType
        dropDownType.selectRow(at: 0)
        self.txtType.text = dsType[0]
        dropDownType.selectionAction = { [unowned self] (index, item) in
            self.selectedTypeIndex = index
            self.txtType.text = dsType[index]
            self.loadData(groupIndex: self.selectedGroupIndex, typeIndex: self.selectedTypeIndex)
        }
        dropDownType.dismissMode = .automatic
        dropDownType.direction = .any
    }
    
    func viewGroupTapped() {
        dropDownGroup.show()
    }
    
    func viewTypeTapped() {
        dropDownType.show()
    }
    
    func loadData(groupIndex: Int = -1, typeIndex: Int = 0) {
        let dataSource = SpendyRepo.shared.list.filter({
            let itemDate = ($0.date! as Date).startOfDate()
            return (itemDate.isEqualDate(self.fromDate) ||
                itemDate.isGreaterThanDate(self.fromDate)) &&
                (itemDate.isEqualDate(self.toDate) ||
                itemDate.isLessThanDate(self.toDate))
        })
        
        let earlyData = SpendyRepo.shared.list.filter({
            let itemDate = ($0.date! as Date).startOfDate()
            return itemDate.isLessThanDate(self.fromDate)
        })

        start = 0
        for item in earlyData {
            start += Int(item.money)
        }
        
        incoming = 0
        outgoing = 0
        spendySections.removeAll()
        var sectionIndex = 0
        for item in dataSource {
            if item.money > 0 {
                incoming += Int(item.money)
            }
            else {
                outgoing -= Int(item.money)
            }
            
            if (groupIndex == -1 || GroupRepo.shared.list[groupIndex].id == item.groupID) {
                if typeIndex == 0 || (typeIndex == 1 && item.money > 0) || (typeIndex == 2 && item.money < 0) {
                    let curTitle = (item.date! as Date).toString(withFormat: "dd / MM / yyyy")
                    var curSection = SpendySection()
                    if let section = spendySections.first(where: { $0.title == curTitle }) {
                        curSection = section
                    }
                    else {
                        curSection.index = sectionIndex
                        curSection.title = curTitle
                        spendySections.append(curSection)
                        sectionIndex += 1
                    }
                    
                    curSection.spendies.append(item)
                }
            }
        }
        
        end = start + incoming - outgoing
        
        tableView.reloadData()
    }
    
    // Navigation
    
    // View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // remove odd rows
        tableView.tableFooterView = UIView()
        
        // register cell
        tableView.register(UINib(nibName: cellNibName, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        // tableview row height systaltic
        tableView.estimatedRowHeight = 93
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setupDropDown()
        
        viewGroup.isUserInteractionEnabled = true
        viewGroup.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewGroupTapped)))
        
        viewType.isUserInteractionEnabled = true
        viewType.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTypeTapped)))
        
        loadData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        viewTop.layer.borderWidth = 1
        viewBottom.layer.borderWidth = 1
        tableView.layer.borderWidth = 1
        
        viewTop.layer.cornerRadius = 10
        viewBottom.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
    }
}

extension ReportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if spendySections.count == 0 {
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
        return spendySections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spendySections[section].spendies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SpendyTableViewCell
        let spendy = spendySections[indexPath.section].spendies[indexPath.row]
        cell.setData(spendy)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return spendySections[section].title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.tintColor = (0x1b4aa6).toUIColor()
        header.textLabel?.textColor = UIColor.white
    }
}
