//
//  SetViewController.swift
//  iZP
//
//  Created by TONY on 22/06/2017.
//  Copyright © 2017 TONY COMPANY. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class SetViewController: UIViewController {
    
    @IBOutlet weak var salaryTextField: UITextField!
    @IBOutlet weak var lunchTextField: UITextField!
    @IBOutlet weak var correctionTextField: UITextField!
    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var lunchSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        salaryTextField.text! = "\(SETTINGS.salary)"
        lunchTextField.text! = "\(SETTINGS.lunchTime)"
        correctionTextField.text! = "\(SETTINGS.correctionTime)"
        currencyTextField.text! = SETTINGS.currency
        lunchSwitch.setOn(SETTINGS.lunchBool, animated: true)
        
        salaryTextField.inputAccessoryView = setUpDoneButton()
        lunchTextField.inputAccessoryView = setUpDoneButton()
        correctionTextField.inputAccessoryView = setUpDoneButton()
        currencyTextField.inputAccessoryView = setUpDoneButton()
        
        salaryTextField.keyboardType = .decimalPad
        lunchTextField.keyboardType = .decimalPad
        correctionTextField.keyboardType = .decimalPad
    }
    
    @IBAction func salaryAction(_ sender: UITextField) {
        if let salary = Double(salaryTextField.text!) {
            changeSettingsInCoreDate(key: "salary", value: salary)
            SETTINGS.salary = salary
        } else {
            alert(title: "Error", message: "Invalid Salary!")
        }
    }
    @IBAction func lunchAction(_ sender: UITextField) {
        if let lunch = Double(salaryTextField.text!) {
            changeSettingsInCoreDate(key: "lunchTime", value: lunch)
            SETTINGS.lunchTime = lunch
        } else {
            alert(title: "Error", message: "Invalid Lunch time!")
        }
    }
    @IBAction func correctionAction(_ sender: UITextField) {
        if let correction = Double(correctionTextField.text!) {
            changeSettingsInCoreDate(key: "correctionTime", value: correction)
            SETTINGS.correctionTime = correction
        } else {
            alert(title: "Error", message: "Invalid Correction time!")
        }
    }
    @IBAction func currencyAction(_ sender: UITextField) {
        changeSettingsInCoreDate(key: "currency", value: currencyTextField.text!)
        SETTINGS.currency = currencyTextField.text!
    }
    @IBAction func lunchSwitchAction(_ sender: UISwitch) {
        changeSettingsInCoreDate(key: "lunchBool", value: lunchSwitch.isOn)
        SETTINGS.lunchBool = lunchSwitch.isOn
    }
    @IBAction func cleanHistory(_ sender: UIButton) {
        cleanMonths()
        alert(title: "Success", message: "History was cleaned")
    }
    
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
