//
//  Exr.swift
//  iZP
//
//  Created by TONY on 19/07/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@available(iOS 10.0, *)
extension UIViewController {
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveData(_ context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func loadSettings() {
        let context = getContext()
        
        let request = NSFetchRequest<Set>(entityName: "Set")
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            if let settings = result.first {
                SETTINGS.salary = settings.salary
                SETTINGS.lunchTime = settings.lunchTime
                SETTINGS.correctionTime = settings.correctionTime
                SETTINGS.currency = settings.currency!
                SETTINGS.lunchBool = settings.lunchBool
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "Set", in: context)
                let newSet = NSManagedObject(entity: entity!, insertInto: context)
                newSet.setValue(SETTINGS.salary, forKey: "salary")
                newSet.setValue(SETTINGS.lunchTime, forKey: "lunchTime")
                newSet.setValue(SETTINGS.correctionTime, forKey: "correctionTime")
                newSet.setValue(SETTINGS.currency, forKey: "currency")
                newSet.setValue(SETTINGS.lunchBool, forKey: "lunchBool")
                
                alert(title: "Attention", message: "Set up app for you in Settings")
            }
        } catch { print("Failed fetching") }
    }
    
    func loadMonth(_ month: String) -> Month {
        let context = getContext()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Month")
        request.predicate = NSPredicate(format: "month = %@", month)
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        let result = try? context.fetch(request) as! [Month]
        if let fetchMonth = result?.first {
            return fetchMonth
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "Month", in: context)
            let newMonth = NSManagedObject(entity: entity!, insertInto: context)
            
            newMonth.setValue(month, forKey: "month")
            newMonth.setValue(0, forKey: "prepaid")
            
            saveData(context)
            
            return newMonth as! Month
        }
    }
}
