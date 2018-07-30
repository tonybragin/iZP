//
//  EditorViewController.swift
//  iZP
//
//  Created by TONY on 19/07/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class EditorViewController: UIViewController {

    @IBOutlet weak var dayTextField: UITextField!
    
    @IBOutlet weak var getInHoursTextField: UITextField!
    @IBOutlet weak var getInMinutesTextField: UITextField!
    @IBOutlet weak var getOutHoursTextField: UITextField!
    @IBOutlet weak var getOutMinutesTextField: UITextField!
    
    @IBOutlet weak var lunchTextField: UITextField!
    @IBOutlet weak var summaryTextField: UITextField!
    @IBOutlet weak var earnLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var month: Month!
    var day: Day?
    var isNewDay: Bool = false
    var isAdd: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up done button
        dayTextField.inputAccessoryView = setUpDoneButton()
        
        getInHoursTextField.inputAccessoryView = setUpDoneButton()
        getInMinutesTextField.inputAccessoryView = setUpDoneButton()
        getOutHoursTextField.inputAccessoryView = setUpDoneButton()
        getOutMinutesTextField.inputAccessoryView = setUpDoneButton()
        
        lunchTextField.inputAccessoryView = setUpDoneButton()
        summaryTextField.inputAccessoryView = setUpDoneButton()
        
        //Set up keyboards type
        dayTextField.keyboardType = .numberPad
        
        getInHoursTextField.keyboardType = .numberPad
        getInMinutesTextField.keyboardType = .numberPad
        getOutHoursTextField.keyboardType = .numberPad
        getOutMinutesTextField.keyboardType = .numberPad
        
        lunchTextField.keyboardType = .decimalPad
        summaryTextField.keyboardType = .decimalPad
        
        //Set up view
        
        if day != nil {
            dayTextField.text! = day!.day!
            
            getInHoursTextField.text! = getPrintable(digit: Int(day!.getInHours))
            getInMinutesTextField.text! = getPrintable(digit: Int(day!.getInMinutes))
            getOutHoursTextField.text! = getPrintable(digit: Int(day!.getOutHours))
            getOutMinutesTextField.text! = getPrintable(digit: Int(day!.getOutMinutes))
            
            lunchTextField.text! = "\(day!.lunch)"
            
            summaryTextField.text! = getPrintableDouble(digit: day!.hours)
            earnLabel.text! = getPrintableDouble(digit: day!.earn) + "\(SETTINGS.currency)"
        } else {
            isNewDay = true
            
            if SETTINGS.lunchBool {
                lunchTextField.text! = "\(SETTINGS.lunchTime)"
            }
            
            let context = getContext()
            let entity = NSEntityDescription.entity(forEntityName: "Day", in: context)!
            
            day = Day(entity: entity, insertInto: context)
            initDay()
        }

        if isNewDay {
            addButton.setTitle("Add", for: .normal)
            deleteButton.isHidden = true
        } else {
            addButton.setTitle("Edit", for: .normal)
            deleteButton.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !isAdd && isNewDay {
            let context = getContext()
            context.delete(day!)
            saveData(context)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dayAction(_ sender: UITextField) {
        if let dayDigit = Int(dayTextField.text!) {
            if isValid(for: .days, digit: dayDigit) {
                day!.day = getPrintable(digit: dayDigit)
            }
        } else { alert(title: "Error", message: "Invalid day") }
    }
    
    @IBAction func getInHoursAction(_ sender: UITextField) {
        if let hourDigit = Int(getInHoursTextField.text!) {
            if isValid(for: .hours, digit: hourDigit) {
                day!.getInHours = Int32(hourDigit)
                
                if canCalculate() {
                    calculations()
                }
            }
        } else { alert(title: "Error", message: "Invalid hour") }
    }
    
    @IBAction func getInMinutesAction(_ sender: UITextField) {
        if let minuteDigit = Int(getInMinutesTextField.text!) {
            if isValid(for: .minutes, digit: minuteDigit) {
                day!.getInMinutes = Int32(minuteDigit)
                
                if canCalculate() {
                    calculations()
                }
            }
        } else { alert(title: "Error", message: "Invalid minute") }
    }
    
    @IBAction func getOutHoursAction(_ sender: UITextField) {
        if let hourDigit = Int(getOutHoursTextField.text!) {
            if isValid(for: .hours, digit: hourDigit) {
                day!.getOutHours = Int32(hourDigit)

                if canCalculate() {
                    calculations()
                }
            }
        } else { alert(title: "Error", message: "Invalid hour") }
    }
    
    @IBAction func getOutMinutesAction(_ sender: UITextField) {
        if let minuteDigit = Int(getOutMinutesTextField.text!) {
            if isValid(for: .minutes, digit: minuteDigit) {
                day!.getOutMinutes = Int32(minuteDigit)
                
                if canCalculate() {
                    calculations()
                }
            }
        } else { alert(title: "Error", message: "Invalid minute") }
    }
    
    @IBAction func lunchAction(_ sender: UITextField) {
        if let lunch = Double(lunchTextField.text!) {
            day!.lunch = lunch
            
            if canCalculate() {
                calculations()
            }
        } else { alert(title: "Error", message: "Invalid lunch time") }
    }
    
    @IBAction func summaryAction(_ sender: UITextField) {
        getInHoursTextField.text! = "00"
        getInMinutesTextField.text! = "00"
        getOutHoursTextField.text! = "00"
        getOutMinutesTextField.text! = "00"
        
        if let hours = Double(summaryTextField.text!) {
            day!.getInHours = 0
            day!.getInMinutes = 0
            day!.getOutHours = 0
            day!.getOutMinutes = 0
            
            day!.hours = hours
            day!.earn = (hours - day!.lunch) * SETTINGS.salary
            earnLabel.text! = "\(day!.earn)"
        } else { alert(title: "Error", message: "Invalid summary") }
    }
    
    @IBAction func AddAction(_ sender: UIButton) {
        if dayTextField.text! == "" {
            alert(title: "Error", message: "Write day")
            return
        }
        
        if summaryTextField.text! == "" {
            if canCalculate() {
                calculations()
            }
        }
        
        let context = getContext()
        saveData(context)
        
        isAdd = true
    self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
        let context = getContext()
        context.delete(day!)
        saveData(context)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
