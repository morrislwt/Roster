//
//  File.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/29.
//  Copyright © 2018年 Morris. All rights reserved.
//

import RealmSwift

class EmployeeData : Object, AddDataToRealm, EditProtocol {


    @objc dynamic var employeeName: String = ""
    
    func add(_ text: String) {
        self.employeeName = text
    }
    func edit()->String {
        return employeeName
    }
    func result(_ text: String) {
        self.employeeName = text
    }
}

