//
//  MainViewController.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/17/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import UIKit
import JTAppleCalendar

class MainViewController: UIViewController {

    // Properties
    let formatter = DateFormatter()
    var selectedMonth = 0
    var selectedYear = 0
    var selectedDate = Date()
    
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
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var lblStartMoney: UILabel!
    @IBOutlet weak var lblEndMoney: UILabel!
    @IBOutlet weak var lblIncoming: UILabel!
    @IBOutlet weak var lblOutgoing: UILabel!
    
    // Actions
    @IBAction func today(_ sender: Any) {
        scrollTo(date: Date())
    }
    
    @IBAction func showDetail(_ sender: Any) {
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    // Methods
    func scrollTo(month: Int, year: Int) {
        formatter.dateFormat = "ddMMyyyy"
        var monthStr = month >= 10 ? "" : "0"
        monthStr += "\(month)"
        let date = formatter.date(from: "01\(monthStr)\(year)")!
        calendarView.scrollToDate(date)
    }
    
    func scrollTo(date: Date) {
        calendarView.scrollToDate(date)
    }
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.scrollToDate(Date())
    }
    
    func selectMonth() {
        self.performSegue(withIdentifier: "selectMonth", sender: self)
    }
    
    func selectYear() {
        self.performSegue(withIdentifier: "selectYear", sender: self)
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? CalendarCell else { return }
        validCell.viewCurrent.isHidden = !validCell.isSelected
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SelectMonthTableViewController {
            vc.mainVC = self
            vc.selectedIndex = selectedMonth - 1
        }
        else if let vc = segue.destination as? SelectYearTableViewController {
            vc.mainVC = self
            vc.selectedYear = selectedYear
        }
        else if let vc = segue.destination as? SpendyTableViewController {
            vc.selectedDate = self.selectedDate
        }
    }
    
    // View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendarView()
        
        let selectMonthTouch = UITapGestureRecognizer(target: self, action: #selector(selectMonth))
        lblMonth.addGestureRecognizer(selectMonthTouch)
        
        let selectYearTouch = UITapGestureRecognizer(target: self, action: #selector(selectYear))
        lblYear.addGestureRecognizer(selectYearTouch)
    }
}

extension MainViewController: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "dd MM yyyy"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "01 01 2000")!
        let endDate = formatter.date(from: "01 01 2100")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        cell.lblDate.text = cellState.text
        cell.lblDate.textColor = cell.textColor
        cell.date = date
        
        if cellState.dateBelongsTo == .thisMonth {
            cell.alpha = 1
        }
        else {
            cell.alpha = 0.5
        }
        
        if Calendar.current.compare(Date(), to: cell.date, toGranularity: .day) == .orderedSame {
            cell.isToday = true
        }
        
        cell.viewCurrent.isHidden = true
        if Calendar.current.compare(selectedDate, to: cell.date, toGranularity: .day) == .orderedSame {
            cell.viewCurrent.isHidden = false
        }
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        guard let cell = cell as? CalendarCell else { return true }
        cell.viewCurrent.isHidden = true
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else { return }
        handleCellSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? CalendarCell else { return }
        
        selectedDate = cellState.date
        
        if cellState.dateBelongsTo != .thisMonth {
            calendarView.scrollToDate(cellState.date)
            calendar.reloadData()
        }
        else {
            handleCellSelected(view: cell, cellState: cellState)
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        lblYear.text = formatter.string(from: date)
        selectedYear = Int(lblYear.text!)!
        
        var monthStr = "Tháng "
        formatter.dateFormat = "MM"
        let month = Int(formatter.string(from: date))!
        selectedMonth = month
        
        switch month {
        case 1:
            monthStr += "Một"
        case 2:
            monthStr += "Hai"
        case 3:
            monthStr += "Ba"
        case 4:
            monthStr += "Tư"
        case 5:
            monthStr += "Năm"
        case 6:
            monthStr += "Sáu"
        case 7:
            monthStr += "Bảy"
        case 8:
            monthStr += "Tám"
        case 9:
            monthStr += "Chín"
        case 10:
            monthStr += "Mười"
        case 11:
            monthStr += "Mười Một"
        case 12:
            monthStr += "Mười Hai"
        default:
            break
        }
        
        lblMonth.text = monthStr
    }
}
