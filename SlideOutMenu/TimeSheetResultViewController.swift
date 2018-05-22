//
//  TimeSheetResultViewController.swift
//  Roster
//
//  Created by Morris on 2018/5/22.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift


class TimeSheetResultViewController:UIViewController{
    @IBOutlet weak var resultTableView: UITableView!
    let realm = try! Realm()
    
    var dateFrom:Date = Date()
    var dateTo:Date = Date()
    var person:String = ""
    var number = 0
    var filterPerson:Results<ShiftDataToCalender>?
    func loadFilterStaff(name:String){
        filterPerson = realm.objects(ShiftDataToCalender.self).filter("staff = %@", name)
        number = filterPerson?.count ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFilterStaff(name: person)
    }
}


extension TimeSheetResultViewController:UITableViewDataSource,UITabBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterPerson?.count ?? 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if let personInfo = filterPerson?[indexPath.row]{
            cell.textLabel?.text = "\((personInfo.totalWorkMinutes / 60)) Hours, \((personInfo.totalWorkMinutes) % 60) Minutes"
            if let date = personInfo.shiftDate{
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                let shortDate = formatter.string(from: date)
                cell.detailTextLabel?.text = shortDate
            }
            
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sumOfHours:Int = 0
        for i in 0...(number - 1){
            if number >= 0 {
                sumOfHours += (filterPerson?[i].totalWorkMinutes)!
            }
        }

        return "Total Work : \((sumOfHours) / 60) Hours, \((sumOfHours % 60 )) Mins."
    }
}
