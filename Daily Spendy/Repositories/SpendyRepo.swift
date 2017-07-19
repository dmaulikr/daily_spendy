//
//  SpendyRepo.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/18/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SpendyRepo {
    
    // Shared
    static var shared = SpendyRepo()
    
    // Properties
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!
    var list = [Spendy]()
    
    // Methods
    func getByDate(_ date: Date) -> [Spendy] {
        return []
    }
    
    private func generateID() -> String {
        var id = ""
        while id == "" || list.filter({ $0.id == id }).count > 0 {
            id = Date().toString(withFormat: "ddMMyyyyHHmm") + "_" + randomString(length: 4)
        }
        
        return id
    }
    
    func loadData() {
        list.removeAll()
        do {
            list = try context.fetch(Spendy.fetchRequest())
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func insert(name: String, money: Int, groupID: String, date: Date) {
        let spendy = Spendy(context: context)
        spendy.id = generateID()
        spendy.name = name
        spendy.money = Int64(money)
        spendy.date = date as NSDate
        spendy.groupID = groupID
        
        appDelegate.saveContext()
        loadData()
    }
    
    func update(spendy: Spendy) {
        appDelegate.saveContext()
        loadData()
    }
    
    func delete(spendy: Spendy) {
        context.delete(spendy)
        appDelegate.saveContext()
        loadData()
    }
    
    // Constructors
    init() {
        appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        loadData()
    }
}
