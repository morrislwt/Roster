//
//  MyShiftViewController.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/20.
//  Copyright © 2018年 Morris. All rights reserved.
//

import Foundation
import RealmSwift

enum SelectedCollectionItem:Int{
    case staff = 0
    case place
    case position
    case shift
}

class DashboardViewController:UIViewController{
    
    @IBAction func backDashboard(_ segue:UIStoryboardSegue){
        
    }
    @IBAction func addButton(_ sender: UIButton) {
        switch dataIndex {
        case SelectedCollectionItem.staff.rawValue:
            showStaffAlert()
        case SelectedCollectionItem.place.rawValue:
            showWorkPlaceAlert()
        case SelectedCollectionItem.position.rawValue:
            showPositionAlert()
        case SelectedCollectionItem.shift.rawValue:
            performSegue(withIdentifier: "goShift", sender: self)
        default:
            break
        }
    }
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
        shiftTemplate = realm.objects(shiftTemplateData.self).sorted(byKeyPath: "shiftTimeStart", ascending: true)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
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
        case SelectedCollectionItem.staff.rawValue:
            cell.backgroundColor = indexPath.item == 0 ? .white : .clear
        case SelectedCollectionItem.place.rawValue:
            cell.backgroundColor = indexPath.item == 1 ? .white : .clear
        case SelectedCollectionItem.position.rawValue:
            cell.backgroundColor = indexPath.item == 2 ? .white : .clear
        case SelectedCollectionItem.shift.rawValue:
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
        case SelectedCollectionItem.staff.rawValue:
            return staff?.count ?? 1
        case SelectedCollectionItem.place.rawValue:
            return workPlace?.count ?? 1
        case SelectedCollectionItem.position.rawValue:
            return position?.count ?? 1
        case SelectedCollectionItem.shift.rawValue:
            return shiftTemplate?.count ?? 1
        default:
            break
        }
        return 1
//        switch dataIndex {
//        case 0:
//            return staff?.count ?? 1
//        case 1:
//            return workPlace?.count ?? 1
//        case 2:
//            return position?.count ?? 1
//        case 3:
//            return shiftTemplate?.count ?? 1
//        default:
//            break
//        }
//        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.textColor = .white
        switch dataIndex {
        case SelectedCollectionItem.staff.rawValue:
            cell.textLabel?.text = staff?[indexPath.row].employeeName
            cell.backgroundColor = .clear
        case SelectedCollectionItem.place.rawValue:
            cell.textLabel?.text = workPlace?[indexPath.row].placename
            cell.backgroundColor = .clear
        case SelectedCollectionItem.position.rawValue:
            cell.textLabel?.text = position?[indexPath.row].positionName
            cell.backgroundColor = .clear
        case SelectedCollectionItem.shift.rawValue:
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle  == .delete {
            if dataIndex == SelectedCollectionItem.staff.rawValue{
               print("staffTable,delete\(indexPath.row)")
            }else{
               print("otherTable,delete\(indexPath.row)")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.updateModel(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
        
        return [delete]
    }
    func updateModel(at indexPath:IndexPath){
        switch dataIndex {
        case SelectedCollectionItem.staff.rawValue:
            guard let staffForDelete = staff?[indexPath.row] else { return }
            deleteModel(modelForDelete: staffForDelete)
        case SelectedCollectionItem.place.rawValue:
            guard let placeForDelete = workPlace?[indexPath.row] else { return }
            deleteModel(modelForDelete: placeForDelete)
        case SelectedCollectionItem.position.rawValue:
            guard let positionForDelete = position?[indexPath.row] else { return }
            deleteModel(modelForDelete: positionForDelete)
        case SelectedCollectionItem.shift.rawValue:
            guard let shiftForDelete = shiftTemplate?[indexPath.row] else { return }
            deleteModel(modelForDelete: shiftForDelete)
        default:
            break
        }
        
    }
    func deleteModel(modelForDelete:Object){
        do{
            try realm.write {
                realm.delete(modelForDelete)
            }
        }catch{
            print("Error deleting model, \(error)")
        }
    }
    func editModel(){
        
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
    
    func showStaffAlert(){
        let staffName = UITextField()
        let alert = UIAlertController(style: .alert, title: "Add New Staff")
        let image = UIImage(named: "Employees")
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.placeholder = "Staff name"
            textField.autocapitalizationType = .words
            textField.left(image: image,color: .gray)
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.returnKeyType = .done
            textField.action { textField in
                staffName.text = textField.text
            }
        }
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            guard staffName.text != "" else { return }
            let newStaff = EmployeeData()
            newStaff.employeeName = staffName.text!
            self.saveObject(to: newStaff)
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.show()
    }
    func showWorkPlaceAlert(){
        let placeName = UITextField()
        let alert = UIAlertController(style: .alert, title: "Add New Place")
        let image = UIImage(named: "place")
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.placeholder = "Place name"
            textField.autocapitalizationType = .words
            textField.left(image: image,color: .gray)
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.returnKeyType = .done
            textField.action { textField in
                placeName.text = textField.text
            }
        }
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            guard placeName.text != "" else { return }
            let newPlace = WorkSpaceData()
            newPlace.placename = placeName.text!
            self.saveObject(to: newPlace)
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.show()
    }
    func showPositionAlert(){
        let positionName = UITextField()
        let alert = UIAlertController(style: .alert, title: "Add New Position")
        let image = UIImage(named: "position")
        let config: TextField.Config = { textField in
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.placeholder = "Position name"
            textField.autocapitalizationType = .words
            textField.left(image: image,color: .gray)
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.returnKeyType = .done
            textField.action { textField in
                positionName.text = textField.text
            }
        }
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            guard positionName.text != "" else { return }
            let newPosition = PositionData()
            newPosition.positionName = positionName.text!
            self.saveObject(to: newPosition)
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.show()
    }
    func saveObject(to dataModel: Object){
        do{
            try realm.write {
                realm.add(dataModel)
            }
        }catch{
            print("Error saving dataModel \(error)")
        }
        dashboardTableView.reloadData()
    }
}

