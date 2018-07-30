//
//  ExtentionsSet.swift
//  iZP
//
//  Created by TONY on 30/07/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@available(iOS 10.0, *)
extension SetViewController {
    
    func cleanMonths() {
        let context = getContext()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Month")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "month != %@", getCurrentMonth())
        
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            for object in result {
                context.delete(object)
            }
        } catch  { print("Failed fetching") }
    }
    
    func changeSettingsInCoreDate(key: String, value: Any) {
        let context = getContext()
        
        let request = NSFetchRequest<Set>(entityName: "Set")
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            let settings = result.first!
            settings.setValue(value, forKey: key)
        } catch { print("Failed fetching") }
        
        saveData(context)
    }
    
}
