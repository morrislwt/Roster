//
//  WorkSpaceData.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/26.
//  Copyright © 2018年 Morris. All rights reserved.
//

import RealmSwift

class WorkSpaceData : Object, AddDataToRealm, EditProtocol {

    @objc dynamic var placename: String = ""
    
    func add(_ text: String) {
        self.placename = text
    }
    func edit()->String {
        return placename
    }
    func result(_ text: String) {
        self.placename = text
    }
    
}

// 1. 3 objects -> 1 ?? AddRow (protocol)
// 2. 確保同一個物件都有 func 寫入 realm data 內
