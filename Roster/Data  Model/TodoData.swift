//
//  TodoData.swift
//  Roster
//
//  Created by Morris on 2018/5/21.
//  Copyright © 2018年 Morris. All rights reserved.
//

import RealmSwift

class TodoData : Object{
    
    @objc dynamic var title: String = ""
    @objc dynamic var subtitle: String = ""
    @objc dynamic var isChecked: Bool = false
    @objc dynamic var createDate:Date = Date()
    @objc dynamic var agendaKey:String = ""
}
