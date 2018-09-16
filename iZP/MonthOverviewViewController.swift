//
//  MonthOverviewViewController.swift
//  iZP
//
//  Created by TONY on 19/07/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class MonthOverviewViewController: UIViewController {
    
    @IBOutlet weak var earnLabel: UILabel!
    @IBOutlet weak var prepaidLabel: UILabel!
    @IBOutlet weak var deptLabel: UILabel!
    @IBOutlet weak var earnBefore15Label: UILabel!
    @IBOutlet weak var predictionLabel: UILabel!
    
    var month: String!
    var loadedMonth: Month!
    
    var earn = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showHoursAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "MonthOverviewToMonthTable", sender: loadedMonth)
    }
    @IBAction func addHoursAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "MonthOverviewToEditor", sender: loadedMonth)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MonthTableViewController {
            controller.month = sender! as! Month
        }
        if let controller = segue.destination as? EditorViewController {
            controller.month = sender! as! Month
        }
    }
    
    @IBAction func prepaidAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Edit prepaid", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.text! = ""
            textField.keyboardType = .decimalPad
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { (action) in
            if let prepaid = Double(alert.textFields![0].text!) {
                let context = self.getContext()
                self.loadedMonth.prepaid = prepaid
                self.saveData(context)
                
                self.prepaidLabel.text! = "\(prepaid)\(SETTINGS.currency)"
                self.deptLabel.text! = self.getPrintableDouble(self.earn - prepaid) + "\(SETTINGS.currency)"
            } else {
                self.alert(title: "Error", message: "Invalid prepaid")
                return
            }
        })
        
        self.present(alert, animated: true)
    }
    
    func setUpView() {
        self.loadedMonth = loadMonth(month)
        let loadedDays = self.loadedMonth.days?.allObjects as! [Day]
        
        self.earn = 0.0
        var earnBefore15 = 0.0
        
        for day in loadedDays {
            self.earn += day.earn
            if Int(day.day!)! <= 15 {
                earnBefore15 += day.earn
            }
        }
            
        self.earnLabel.text! =  getPrintableDouble(earn) + "\(SETTINGS.currency)"
        self.prepaidLabel.text! = getPrintableDouble(loadedMonth.prepaid) + "\(SETTINGS.currency)"
        self.deptLabel.text! = getPrintableDouble(earn - loadedMonth.prepaid) + "\(SETTINGS.currency)"
        self.earnBefore15Label.text! = getPrintableDouble(earnBefore15) + "\(SETTINGS.currency)"
        self.predictionLabel.text! = getPrintableDouble(predictionCalculate(loadedDays)) + "\(SETTINGS.currency)"
    }
    
    func predictionCalculate(_ days: [Day]) -> Double {
        var sy = 0.0
        var sx = 0.0
        var p = 0.0
        
        for day in days {
            sy += p + day.hours
            sx += Double(day.day!)!
            p += day.hours
        }
        
        let k = (sy / Double(days.count)) / (sx / Double(days.count))
        
        if k > 0 {
            return 30 * k * SETTINGS.salary
        } else { return 0 }
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
