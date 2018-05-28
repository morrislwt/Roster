//
//  PositionData.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/29.
//  Copyright © 2018年 Morris. All rights reserved.
//

import RealmSwift

class PositionData : Object, AddDataToRealm, EditProtocol {

    @objc dynamic var positionName: String = ""
    
    func add(_ text: String) {
        self.positionName = text
    }
    
    func edit()->String {
        print("position",positionName)

        return positionName
    }
    func result(_ text: String) {
        self.positionName = text
    }
    
}

