//
//  shiftData.swift
//  Roster
//
//  Created by Morris on 2018/5/6.
//  Copyright © 2018年 Morris. All rights reserved.
//


import RealmSwift

class shiftTemplateData : Object{
    
    @objc dynamic var shiftTemplateName: String = ""
    @objc dynamic var shiftTimeStart: String = ""
    @objc dynamic var shiftTimeEnd: String = ""
}
