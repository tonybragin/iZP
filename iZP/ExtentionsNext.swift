//
//  ExtentionsNext.swift
//  iZP
//
//  Created by TONY on 30/07/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@available(iOS 10.0, *)
extension NextViewController {
    
    func planCalculation(_ plan: Double) {
        var calculations = plan / SETTINGS.salary
        hoursInMonth.text! = getPrintableDouble(calculations)
        calculations /= 4
        hoursInWeek.text! = getPrintableDouble(calculations)
        calculations /= 5
        hoursInDay.text! = getPrintableDouble(calculations)
    }
    
    func loadPlan() -> Int {
        let context = getContext()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NextMonth")
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            if let plan = result.first {
                return plan.value(forKey: "plan") as! Int
            } else {
                let entity = NSEntityDescription.entity(forEntityName: "NextMonth", in: context)
                let newPlan = NSManagedObject(entity: entity!, insertInto: context)
                newPlan.setValue(0, forKey: "plan")
                
                saveData(context)
                return 0
            }
        } catch {
            print("Failed fetching")
            return 0
        }
    }
    
    func changePlanInCoreDate(_ plan: Int) {
        let context = getContext()
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NextMonth")
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request) as! [NSManagedObject]
            result.first!.setValue(plan, forKey: "plan")
            
        } catch { print("Failed fetching") }
        
        saveData(context)
    }
    
}
