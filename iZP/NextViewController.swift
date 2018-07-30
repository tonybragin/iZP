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
    
}
