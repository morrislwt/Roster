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
    
    @IBAction func backButton(_ sender: UIButton) {
        performSegue(withIdentifier: "backTimeSheet", sender: self)
        
    }
    @IBOutlet weak var backOutlet: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var resultTableView: UITableView!
    let realm = try! Realm()
    
    var dateFrom:Date = Date()
    var dateTo:Date = Date()
    var choosePerson:String = ""
    var filterPerson:Results<ShiftDataToCalender>?
    
    func loadFilterStaff(name:String){
        
        filterPerson = realm.objects(ShiftDataToCalender.self).filter("staff = %@", name).filter("shiftDate >= %@ && shiftDate <= %@",dateFrom,dateTo).sorted(byKeyPath: "shiftDate", ascending: true)
        print(dateFrom,dateTo)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFilterStaff(name: choosePerson)
        if filterPerson?.count == 0 {
            resultTableView.separatorStyle = .none
        }
        resultTableView.layer.cornerRadius = 30
        resultTableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
        backOutlet.layer.cornerRadius = 22
        nameLabel.text = choosePerson
    }
}


extension TimeSheetResultViewController:UITableViewDataSource,UITabBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filterPerson?.count == 0 {
            return 1
        }
        return filterPerson?.count ?? 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if (filterPerson?.count)! > 0 {
            if let personInfo = filterPerson?[indexPath.row]{
                cell.textLabel?.text = "\((personInfo.totalWorkMinutes / 60)) Hours, \((personInfo.totalWorkMinutes) % 60) Minutes"
                cell.backgroundColor = .clear
                if let date = personInfo.shiftDate{
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd MMM YYYY"
                    let shortDate = formatter.string(from: date)
                    cell.detailTextLabel?.text = shortDate
                }
                
            }
        }else{
            cell.backgroundColor = .clear
            cell.textLabel?.textColor = .lightGray
            cell.textLabel?.text = "Oops! Seems no data for this range 😎"
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM YYYY"
        let from = formatter.string(from: dateFrom)
        let to = formatter.string(from: dateTo)
        
        return "\(from) - \(to)"
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        var sumOfHours:Int = 0
        let numberOfData:Int = filterPerson?.count ?? 0
        guard numberOfData > 0 else {return ""}
            for i in 0...(numberOfData - 1){
                guard let totalTime = filterPerson?[i].totalWorkMinutes else { return ""}
                sumOfHours += totalTime
        }
        return "Total Work : \((sumOfHours) / 60) Hours, \((sumOfHours % 60 )) Mins."
    }
}
