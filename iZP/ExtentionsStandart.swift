//
//  Extentions.swift
//  iZP
//
//  Created by TONY on 19/07/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setUpDoneButton() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([doneButton], animated: true)
        
        return toolBar
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    func alert(title: String, message: String) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true)
    }
    
    func getCurrentMonth() -> String {
        let month = Calendar.current.component(.month, from: Date())
        let year = Calendar.current.component(.year, from: Date())
        
        return "\(month).\(year)"
    }
    
    func getPrintableDouble(_ digit: Double) -> String {
        return String(format: "%.2f", digit)
    }
    
    func getPrintable(_ digit: Int) -> String {
        switch digit {
        case 0...9:
            return "0\(digit)"
        default:
            return "\(digit)"
        }
    }
}
