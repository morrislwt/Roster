//
//  UpcomingViewController.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/5/29.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift

class UpcomingViewController:UIViewController{
    var loadIndex = 0{
        didSet{
        }
    }
    var selectRow = ""{
        didSet{
            loadData()
            upcomingTableView.reloadData()
        }
    }
    let realm = try! Realm()

    @IBOutlet weak var upcomingTableView: UITableView!
    
    var shiftData:Results<ShiftDataToCalender>?
    
    func loadData(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 00:00:00 +0000"
        let stringDate = formatter.string(from: date)
        let currentDate = formatter.date(from: stringDate)
        let aWeekLater = Date(timeInterval: 7 * 86400, since: currentDate!)
        if currentDate != nil{
            switch loadIndex {
            //filter by staff
            case 0:
                shiftData = realm.objects(ShiftDataToCalender.self).filter("staff = %@", selectRow).filter("shiftDate >= %@ && shiftDate <= %@",currentDate!,aWeekLater).sorted(byKeyPath: "shiftDate", ascending: true)
            case 1:
                shiftData = realm.objects(ShiftDataToCalender.self).filter("workPlace = %@", selectRow).filter("shiftDate >= %@ && shiftDate <= %@",currentDate!,aWeekLater).sorted(byKeyPath: "shiftDate", ascending: true)
            case 2:
                shiftData = realm.objects(ShiftDataToCalender.self).filter("position = %@", selectRow).filter("shiftDate >= %@ && shiftDate <= %@",currentDate!,aWeekLater).sorted(byKeyPath: "shiftDate", ascending: true)
            case 3:
                shiftData = realm.objects(ShiftDataToCalender.self).filter("shiftName = %@", selectRow).filter("shiftDate >= %@ && shiftDate <= %@",currentDate!,aWeekLater).sorted(byKeyPath: "shiftDate", ascending: true)
            default:
                break
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: .dataIndex, object: nil, queue: OperationQueue.main) { (notification) in
            let vc = notification.object as! DashboardViewController
            self.loadIndex = vc.dataIndex
        }
        NotificationCenter.default.addObserver(forName: .dashboardSelectRow, object: nil, queue: OperationQueue.main) { (notification) in
            let vc = notification.object as! DashboardViewController
            self.selectRow = vc.dashboardSelectRow
            print("Hey",self.selectRow)
        }
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
}

extension UpcomingViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard shiftData?.count > 0 else { return 1}
        return (shiftData?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let formatter = DateFormatter()
        formatter.dateFormat = "eee dd MMM YYYY"
        guard shiftData?.count > 0 else {return cell}
        switch loadIndex {
        case 0:
            guard let date = shiftData?[indexPath.row].shiftDate  else { return cell}
            cell.textLabel?.text = "\(formatter.string(from: date))"
            guard let shift = shiftData?[indexPath.row] else {return cell}
            cell.detailTextLabel?.text = "\(shift.shiftStart) - \(shift.shiftEnd) @ \((shiftData?[indexPath.row].workPlace)!)"
        case 1:
            guard let date = shiftData?[indexPath.row].shiftDate  else { return cell}
            cell.textLabel?.numberOfLines = 2
            cell.textLabel?.text = "\(formatter.string(from: date))\n\((shiftData?[indexPath.row].staff)!)"
            guard let shift = shiftData?[indexPath.row] else {return cell}
            cell.detailTextLabel?.text = "\(shift.shiftStart) - \(shift.shiftEnd)"
            
            
        default:
            break
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title: UILabel = UILabel()
        title.text = selectRow
        title.backgroundColor = .clear
        title.textAlignment = .center
        title.textColor = UIColor(red: 0/255, green: 100/255, blue: 159/255, alpha: 1)
        title.font = UIFont.boldSystemFont(ofSize: 18)
        
        return title
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
