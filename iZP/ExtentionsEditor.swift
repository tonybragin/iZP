//
//  ExtentionsEditor.swift
//  iZP
//
//  Created by TONY on 30/07/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import Foundation
import UIKit
import CoreData

@available(iOS 10.0, *)
extension EditorViewController {
    
    func initDay() {
        day!.day = "00"
        day!.getInHours = 0
        day!.getInMinutes = 0
        day!.getOutHours = 0
        day!.getOutMinutes = 0
        
        if SETTINGS.lunchBool {
            day!.lunch = SETTINGS.lunchTime
        } else {
            day!.lunch = 0
        }
        
        day!.hours = 0
        day!.earn = 0
        day!.thisMonth = month
    }
    
    enum validFor {
        case days
        case hours
        case minutes
    }
    
    func isValid(for type: validFor, digit: Int) -> Bool {
        switch type {
        case .days:
            if digit > 31 || digit < 1 {
                alert(title: "Error", message: "Invalid day")
                return false
            } else { return true }
            
        case .hours:
            if digit > 24 || digit < 0 {
                alert(title: "Error", message: "Invalid hour")
                return false
            } else { return true }
            
        case .minutes:
            if digit > 59 || digit < 0 {
                alert(title: "Error", message: "Invalid minute")
                return false
            } else { return true }
        }
    }
    
    func canCalculate() -> Bool {
        guard let hoursIn = Int(getInHoursTextField.text!) else { return false }
        guard let hoursOut = Int(getOutHoursTextField.text!) else { return false }
        
        if hoursOut - hoursIn >= 0 {
            return true
        } else { return false }
    }
    
    func calculations() {
        let hoursIn = Double(getInHoursTextField.text!)!
        let hoursOut = Double(getOutHoursTextField.text!)!
        
        let minIn = getMinutes(minutes: Double(getInMinutesTextField.text!))
        let minOut = getMinutes(minutes: Double(getOutMinutesTextField.text!))
        
        let summary = hoursOut - hoursIn + minOut - minIn - day!.lunch
        summaryTextField.text! = getPrintableDouble(digit: summary)
        day!.hours = summary
        
        day!.earn = summary * SETTINGS.salary
        earnLabel.text! = getPrintableDouble(digit: day!.earn) + "\(SETTINGS.currency)"
    }
    
    func getMinutes(minutes: Double?) -> Double {
        if let min = minutes {
            return min * (1 / 60)
        } else { return 0 }
    }
    
}
