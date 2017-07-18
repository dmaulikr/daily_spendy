//
//  GroupRepo.swift
//  Daily Spendy
//
//  Created by ProStageVN on 7/18/17.
//  Copyright © 2017 BEN. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GroupRepo {
    
    // Shared
    static var shared = GroupRepo()
    
    // Properties
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!
    var list = [Group]()
    
    // Methods
    func getByID(_ id: String) -> Group? {
        return list.first(where: { $0.id == id })
    }
    
    func getByName(_ name: String) -> [Group] {
        return list.filter({ $0.name == name })
    }
    
    private func generateID() -> String {
        var id = ""
        while id == "" || list.filter({ $0.id == id }).count > 0 {
            id = Date().toString(withFormat: "G") + "_" + randomString(length: 4)
        }
        
        return id
    }
    
    func loadData() {
        list.removeAll()
        do {
            list = try context.fetch(Group.fetchRequest())
            if list.count == 0 {
                let general = Group(context: context)
                general.id = "Ggeneral"
                general.name = "Chung"
                appDelegate.saveContext()
                list = try context.fetch(Group.fetchRequest())
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func insert(name: String) {
        let group = Group(context: context)
        group.id = generateID()
        group.name = name
        
        appDelegate.saveContext()
        loadData()
    }
    
    func update(group: Group) {
        appDelegate.saveContext()
        loadData()
    }
    
    func delete(group: Group) {
        context.delete(group)
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
