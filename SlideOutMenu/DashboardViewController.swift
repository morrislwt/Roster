//
//  MyShiftViewController.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/20.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift
class DashboardViewController:UIViewController{
    @IBOutlet weak var dashboardTableView: UITableView!
    @IBOutlet weak var dashboardCollectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
    
    let realm = try! Realm()
    var staff:Results<EmployeeData>?
    var workPlace:Results<WorkSpaceData>?
    var position:Results<PositionData>?
    var shiftTemplate:Results<shiftTemplateData>?
    var dataIndex:Int = 0
    
    func loadData(){
        staff = realm.objects(EmployeeData.self)
        workPlace = realm.objects(WorkSpaceData.self)
        position = realm.objects(PositionData.self)
        shiftTemplate = realm.objects(shiftTemplateData.self)
    }
    
    let dashboardTitle = ["Staff","Work Place","Position","Shift"]
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        dashboardTableView.layer.cornerRadius = 20
        dashboardTableView.backgroundColor = .clear
        dashboardCollectionView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        dashboardCollectionView.layer.cornerRadius = 10
        dashboardTableView.tableFooterView = UIView()
        menuButton.layer.cornerRadius = 22
    }
}
extension DashboardViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DashboardCollectionViewCell
        cell.dashboardLabel.text = dashboardTitle[indexPath.item]

        switch dataIndex {
        case 0:
            cell.backgroundColor = indexPath.item == 0 ? .white : .clear
        case 1:
            cell.backgroundColor = indexPath.item == 1 ? .white : .clear
        case 2:
            cell.backgroundColor = indexPath.item == 2 ? .white : .clear
        case 3:
            cell.backgroundColor = indexPath.item == 3 ? .white : .clear
        default:
            break
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        ////make sure this scrollView for UICollectionView use.
//        guard let scrollView = scrollView as? UICollectionView else {
//            return
//        }
//        let titleIndex = Int(scrollView.contentOffset.x / CGFloat((view.frame.width)))
//        dataIndex = titleIndex
//        dashboardTableView.reloadData()
//        print("y:",scrollView.contentOffset.y)
//        print("x:",scrollView.contentOffset.x)
//    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let optionWidth = (view.frame.width) * 0.9 / 4
        let optionHeight = view.frame.height * 0.1
        return CGSize(width: optionWidth, height: optionHeight)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataIndex = indexPath.item
        animateTable()
        dashboardCollectionView.reloadData()
        
    }
    
}

extension DashboardViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataIndex {
        case 0:
            return staff?.count ?? 1
        case 1:
            return workPlace?.count ?? 1
        case 2:
            return position?.count ?? 1
        case 3:
            return shiftTemplate?.count ?? 1
        default:
            break
        }
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.textColor = .white
        switch dataIndex {
        case 0:
            cell.textLabel?.text = staff?[indexPath.row].employeeName
            cell.backgroundColor = .clear
        case 1:
            cell.textLabel?.text = workPlace?[indexPath.row].placename
            cell.backgroundColor = .clear
        case 2:
            cell.textLabel?.text = position?[indexPath.row].positionName
            cell.backgroundColor = .clear
        case 3:
            guard let shift = shiftTemplate?[indexPath.row] else { return cell}
            cell.textLabel?.text = shift.shiftTemplateName
            cell.backgroundColor = .clear
            cell.detailTextLabel?.text = "\(shift.shiftTimeStart) - \(shift.shiftTimeEnd)"
            cell.detailTextLabel?.textColor = .lightText
        default:
            break
        }
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func animateTable(){
        dashboardTableView.reloadData()
        let cells = dashboardTableView.visibleCells
        
        let tableviewWidth = dashboardTableView.bounds.size.width
//        let tableViewHeight = dashboardTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: tableviewWidth, y: 0)
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 0.8, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
