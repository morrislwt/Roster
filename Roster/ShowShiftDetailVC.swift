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
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var shiftDetailTableView: UITableView!
    
    let realm = try! Realm()
    var selectIndexFromCal:Int?
    var selectDateInString:String = ""
    let addShiftOptions = ["Date","Staff","Work Place","Position","Shift Name","Shift Start","Shift End","Break Time","Total time","Duty"]
    
    var shiftData:Results<ShiftDataToCalender>?
    var currentDate:Date = Date()
    
    func loadData(date:Date){
        shiftData = realm.objects(ShiftDataToCalender.self).filter("shiftDate = %@", date)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(date: currentDate)
        title = "Shift Detail"
        shiftDetailTableView.tableFooterView = UIView()
        shiftDetailTableView.layer.cornerRadius = 30
        shiftDetailTableView.separatorStyle = .none
        shiftDetailTableView.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 0.5)
        backButton.layer.cornerRadius = 22
    }
}

extension ShowShiftDetailVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.frame.height
        return 50
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
                cell.backgroundColor = .clear
            case 1:
                cell.detailTextLabel?.text = "\(list?.staff ?? "No Data")"
                cell.backgroundColor = .clear
            case 2:
                cell.detailTextLabel?.text = "\(list?.workPlace ?? "No Data")"
                cell.backgroundColor = .clear
            case 3:
                cell.detailTextLabel?.text = "\(list?.position ?? "No Data")"
                cell.backgroundColor = .clear
            case 4:
                cell.detailTextLabel?.text = "\(list?.shiftName == "" ? "None" : list?.shiftName ?? "No Data")"
                cell.backgroundColor = .clear
            case 5:
                cell.detailTextLabel?.text = "\(list?.shiftStart ?? "No Data")"
                cell.backgroundColor = .clear
            case 6:
                cell.detailTextLabel?.text = "\(list?.shiftEnd ?? "No Data")"
                cell.backgroundColor = .clear
            case 7:
                cell.detailTextLabel?.text = "\(hour) Hours, \(min) Mins."
                cell.backgroundColor = .clear
            case 8:
                cell.detailTextLabel?.text = "\((list?.totalWorkMinutes)! / 60) Hours, \((list?.totalWorkMinutes)! % 60) Mins."
                cell.backgroundColor = .clear
            case 9:
                cell.detailTextLabel?.text = "\(list?.duty == "" ? "None" : list?.duty ?? "No Data")"
                cell.backgroundColor = .clear
            default:
                break
            }
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
