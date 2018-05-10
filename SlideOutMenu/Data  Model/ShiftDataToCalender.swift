//
//  ShiftDataToCalender.swift
//  Roster
//
//  Created by Morris on 2018/5/10.
//  Copyright © 2018年 Morris. All rights reserved.
//

import RealmSwift


class ShiftDataToCalender:Object {
    @objc dynamic var shiftDate: Date?
    @objc dynamic var staff: String = ""
    @objc dynamic var workPlace: String = ""
    @objc dynamic var position: String = ""
    @objc dynamic var shiftName: String = ""
    @objc dynamic var shiftStart: String = ""
    @objc dynamic var shiftEnd: String = ""
    @objc dynamic var breakTime: String = ""
    @objc dynamic var totalTime: String = ""
    @objc dynamic var duty: String = ""
    
}
