//
//  ShiftModel.swift
//  Calendar
//
//  Created by Morris on 2018/5/1.
//  Copyright © 2018年 Morris. All rights reserved.
//
////replace by ShiftDataToCalendar

import Foundation
import RealmSwift

class ShiftModel:Object{
    @objc dynamic var staffName:String = ""
    @objc dynamic var date:Date?
    @objc dynamic var shift:String = ""

    
//    init(name: String, date: Date, shift: String) {
//        self.name = name
//        self.date = date
//        self.shift = shift
//    }
}

