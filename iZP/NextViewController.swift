//
//  NextViewController.swift
//  iZP
//
//  Created by TONY on 22/06/2017.
//  Copyright © 2017 TONY COMPANY. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class NextViewController: UIViewController {
    
    @IBOutlet weak var planTextField: UITextField!
    @IBOutlet weak var hoursInMonth: UILabel!
    @IBOutlet weak var hoursInWeek: UILabel!
    @IBOutlet weak var hoursInDay: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        planTextField.keyboardType = .decimalPad
        planTextField.inputAccessoryView = setUpDoneButton()
        
        let plan = loadPlan()
        planTextField.text! = "\(plan)"
        
        planCalculation(Double(plan))
        // Do any additional setup after loading the view.
    }

    @IBAction func planAction(_ sender: Any) {
        if let plan = Int(planTextField.text!) {
            changePlanInCoreDate(plan)
            planCalculation(Double(plan))
        } else {
            alert(title: "Error", message: "Invalid plan!")
        }
    }
    
    func planCalculation(_ plan: Double) {
        var calculations = plan / SETTINGS.salary
        hoursInMonth.text! = getPrintableDouble(digit: calculations)
        calculations /= 4
        hoursInWeek.text! = getPrintableDouble(digit: calculations)
        calculations /= 5
        hoursInDay.text! = getPrintableDouble(digit: calculations)
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
