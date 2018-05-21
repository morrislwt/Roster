//
//  showShiftDetailVC.swift
//  Roster
//
//  Created by Morris on 2018/5/21.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
import RealmSwift

class ShowShiftDetailVC:UIViewController{
    
    @IBOutlet weak var shiftDetailTableView: UITableView!
    
    let realm = try! Realm()
    var selectIndexFromCal:Int?
    var selectDateInString:String = ""
    let addShiftOptions = ["Date","Staff","Work Place","Position","Shift Name","Shift Start","Shift End","Break Time","Total time","Duty"]
    
    var shiftData:Results<ShiftDataToCalender>?
    
    func loadData(){
        shiftData = realm.objects(ShiftDataToCalender.self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        title = "Shift Detail"
        shiftDetailTableView.tableFooterView = UIView()
        
    }
}

extension ShowShiftDetailVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.frame.height
        return height * 80 / height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addShiftOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        
        cell.textLabel?.text = addShiftOptions[indexPath.row]
        if let index = selectIndexFromCal {
            let list = shiftData?[index]
            let hour = (list?.breakMinutes)! / 60
            let min = (list?.breakMinutes)! % 60
            
            switch indexPath.row {
                
            case 0:
                cell.detailTextLabel?.text = selectDateInString
            case 1:
                cell.detailTextLabel?.text = "\(list?.staff ?? "No Data")"
            case 2:
                cell.detailTextLabel?.text = "\(list?.workPlace ?? "No Data")"
            case 3:
                cell.detailTextLabel?.text = "\(list?.position ?? "No Data")"
            case 4:
                cell.detailTextLabel?.text = "\(list?.shiftName ?? "No Data")"
            case 5:
                cell.detailTextLabel?.text = "\(list?.shiftStart ?? "No Data")"
            case 6:
                cell.detailTextLabel?.text = "\(list?.shiftEnd ?? "No Data")"
            case 7:
                cell.detailTextLabel?.text = "\(hour) Hours, \(min) Mins."
            case 8:
                cell.detailTextLabel?.text = "\((list?.totalWorkMinutes)! / 60) Hours, \((list?.totalWorkMinutes)! % 60) Mins."
            case 9:
                cell.detailTextLabel?.text = "\(list?.duty == "" ? "None" : list?.duty ?? "No Data")"
            default:
                break
            }
            
        }
        
//        if let index = selectIndexFromCal {
//            cell.detailTextLabel?.text = "\(shiftData?[index].shiftDate)"
//        }
        return cell
    }
}
