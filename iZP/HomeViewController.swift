//
//  ViewController.swift
//  iZP
//
//  Created by TONY on 21/06/2017.
//  Copyright © 2017 TONY COMPANY. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 11.0, *)
class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSettings()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func thisMonthAction(_ sender: UIButton) {
        performSegue(withIdentifier: "HomeToMonthOverview", sender: getCurrentMonth())
    }
    
    @IBAction func getInAction(_ sender: UIButton) {
        
        let day = Calendar.current.component(.day, from: Date())
        let hours =  Calendar.current.component(.hour, from: Date())
        let min =  Calendar.current.component(.minute, from: Date())
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Day", in: context)!
        
        let dayObject = Day(entity: entity, insertInto: context)
        
        dayObject.day = getPrintable(digit: day)
        dayObject.getInHours = Int32(hours)
        dayObject.getInMinutes = Int32(min)
        
        dayObject.earn = 0
        dayObject.getOutHours = 0
        dayObject.getOutMinutes = 0
        dayObject.hours = 0
        
        if SETTINGS.lunchBool {
            dayObject.lunch = SETTINGS.lunchTime
        } else {
            dayObject.lunch = 0
        }
        
        dayObject.thisMonth = loadMonth(getCurrentMonth())
        
        saveData(context)
        
        alert(title: "Success", message: "You was get in")
    }
    @IBAction func getOutAction(_ sender: UIButton) {
        
        let day = Calendar.current.component(.day, from: Date())
        let hours =  Calendar.current.component(.hour, from: Date())
        let min =  Calendar.current.component(.minute, from: Date())
        
        let context = getContext()
        
        let request = NSFetchRequest<Day>(entityName: "Day")
        request.predicate = NSPredicate(format: "day = %@", getPrintable(digit: day))
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        
        do {
            let result = try context.fetch(request)
            if let dayObject = result.last {
                dayObject.getOutHours = Int32(hours)
                dayObject.getOutMinutes = Int32(min)
                
                dayObject.hours = Double(dayObject.getOutHours - dayObject.getInHours) + (Double(dayObject.getOutMinutes) * 1/60) - (Double(dayObject.getInMinutes) * 1/60) - dayObject.lunch - SETTINGS.correctionTime
                
                dayObject.earn = dayObject.hours * SETTINGS.salary
                
                alert(title: "Success", message: "You was get out")
            } else {
                alert(title: "Error", message: "You didn't get in!")
            }
        } catch { print("Failed fetching") }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? MonthOverviewViewController {
                controller.month = sender! as! String
        }
    }
}

