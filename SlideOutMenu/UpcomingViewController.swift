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
    var aWeekInString: String {
        get{
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "eee dd MMM YYYY 00:00:00 +0000"
            formatter.dateStyle = .medium
            let aWeek = Date(timeInterval: 7 * 86400, since: date)
            return formatter.string(from: aWeek)
        }
        set{
        }
    }
    var loadIndex = 0{
        didSet{
        }
    }
    var selectRow = ""{
        didSet{
            loadData()
            upcomingTableView.reloadData()
            titleLabel.text = "\(selectRow)"
        }
    }
    let realm = try! Realm()

    @IBOutlet weak var upcomingTableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var containerView: UIView!
    var shiftData:Results<ShiftDataToCalender>?
    
    func loadData(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd 00:00:00 +0000"
        formatter.dateStyle = .medium
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
        upcomingTableView.backgroundColor = .clear
        upcomingTableView.separatorColor = .none
        upcomingTableView.tableFooterView = UIView()
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.containerView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.7)
            self.view.layoutIfNeeded()
        }
    }
}

extension UpcomingViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard shiftData?.count > 0 else { return 1}
        return (shiftData?.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let formatter = DateFormatter()
        formatter.dateFormat = "eee dd MMM YYYY"
        let cell = UITableViewCell()
        switch loadIndex {
        case 0:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
            cell.backgroundColor = .clear
            if shiftData?.count == 0 {
                cell.textLabel?.text = "No Availabel Shift Coming. 😎"
            }
            guard shiftData?.count > 0 else {return cell}
            if let date = shiftData?[indexPath.row].shiftDate {
                cell.textLabel?.text = "\(formatter.string(from: date))"
            }
            if let shift = shiftData?[indexPath.row]{
                cell.detailTextLabel?.text = "\(shift.shiftStart) - \(shift.shiftEnd) @ \((shiftData?[indexPath.row].workPlace)!)"
            }
            return cell
        case 1:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
            cell.backgroundColor = .clear
            if shiftData?.count == 0 {
                cell.textLabel?.text = "No Availabel Shift Coming. 😎"
            }
            guard shiftData?.count > 0 else {return cell}
            if let date = shiftData?[indexPath.row].shiftDate {
                cell.textLabel?.numberOfLines = 2
                cell.textLabel?.text = "\(formatter.string(from: date))\n\((shiftData?[indexPath.row].staff)!)"
            }
            if let shift = shiftData?[indexPath.row]{
                cell.detailTextLabel?.text = "\(shift.shiftStart) - \(shift.shiftEnd)"
            }
            return cell
        case 2:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
            cell.backgroundColor = .clear
            if shiftData?.count == 0 {
                cell.textLabel?.text = "No Availabel Shift Coming. 😎"
            }
            guard shiftData?.count > 0 else {return cell}
            if let date = shiftData?[indexPath.row].shiftDate{
                cell.textLabel?.text = "\(formatter.string(from: date))"
                cell.detailTextLabel?.text = "\((shiftData?[indexPath.row].staff)!), \((shiftData?[indexPath.row].shiftStart)!) - \((shiftData?[indexPath.row].shiftEnd)!)"
            }
            return cell
        case 3:
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
            cell.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
            cell.backgroundColor = .clear
            if shiftData?.count == 0 {
                cell.textLabel?.text = "No Availabel Shift Coming. 😎"
            }
            guard shiftData?.count > 0 else {return cell}
            if let date = shiftData?[indexPath.row].shiftDate{
                cell.textLabel?.numberOfLines = 2
                cell.textLabel?.text = "\(formatter.string(from: date))\n\((shiftData?[indexPath.row].staff)!)"
                cell.detailTextLabel?.text = "\((shiftData?[indexPath.row].workPlace)!)"
            }
            return cell
        
        default:
            break
        }
        
        return cell
    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let title: UILabel = UILabel()
//        title.text = selectRow
//        title.backgroundColor = .lightText
//        title.textAlignment = .natural
//        title.font = UIFont(name: "Avenir Next", size: 18)
//
//        return title
//    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Today - \(aWeekInString)"
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
