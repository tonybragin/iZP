//
//  Settings.swift
//  iZP
//
//  Created by TONY on 19/07/2018.
//  Copyright © 2018 TONY COMPANY. All rights reserved.
//

import Foundation

class Setting {
    var salary: Double
    var lunchTime: Double
    var correctionTime: Double
    var currency: String
    var lunchBool: Bool

    init(salary: Double, lunchTime: Double, correctionTime: Double, currency: String, lunchBool: Bool) {
        self.salary = salary
        self.lunchTime = lunchTime
        self.correctionTime = correctionTime
        self.currency = currency
        self.lunchBool = lunchBool
    }
}

var SETTINGS = Setting(salary: 1, lunchTime: 0.5, correctionTime: 0.01, currency: "$", lunchBool: true)
