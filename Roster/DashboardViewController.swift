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
protocol AddDataToRealm {
    func add(_ text: String)
}

protocol EditProtocol {
    func edit()->String
    func result(_ text:String)
}


class DashboardViewController:UIViewController{
//    var setDashboardModel = [String:String]()
    /*
    func addDataToFire(model:String,setValue:[String:String]){
        let databaseRef = Database.database().reference()
        let userUID = Auth.auth().currentUser?.uid
        databaseRef.child(model).child(userUID!).childByAutoId().setValue(setValue)
    }
 */
    /*
    func getDataFromFire(queryBy name:String){
        let userUID = Auth.auth().currentUser?.uid
        let databaseRef = Database.database().reference().queryOrdered(byChild: userUID!)
        databaseRef.observeSingleEvent(of: .value) { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    let tempData = snap.value as? Dictionary<String,String>
                    let key = snap.key
                }
            }
        }
    }
 */
    @IBAction func backDashboard(_ segue:UIStoryboardSegue){
        
    }
    @IBAction func addButton(_ sender: UIButton) {
        switch dataIndex {
        case SelectedCollectionItem.staff.rawValue:
            addModelAlert(alertTitle: "Add New Staff", icon: "Employees", placeHolder: "Staff Name", model: EmployeeData())
        case SelectedCollectionItem.place.rawValue:
            addModelAlert(alertTitle: "Add New Work Place", icon: "place", placeHolder: "Place Name", model: WorkSpaceData())
        case SelectedCollectionItem.position.rawValue:
            addModelAlert(alertTitle: "Add New Position", icon: "position", placeHolder: "Position Name", model: PositionData())
        case SelectedCollectionItem.shift.rawValue:
            performSegue(withIdentifier: "goShift", sender: self)
        default:
            break
        }
    }
    @IBOutlet weak var dashboardTableView: UITableView!
    @IBOutlet weak var dashboardCollectionView: UICollectionView!
    @IBOutlet weak var dashboardLabel: UILabel!
    @IBOutlet weak var dashboardLeading: NSLayoutConstraint!
    @IBOutlet weak var dashboardCollectionLeading: NSLayoutConstraint!
    let realm = try! Realm()
    var staff:Results<EmployeeData>?
    var workPlace:Results<WorkSpaceData>?
    var position:Results<PositionData>?
    var shiftTemplate:Results<shiftTemplateData>?
    var oldIndex:Int = 0
    var dataIndex:Int = 0{
        didSet{
            oldIndex = oldValue
        }
    }
    var dashboardSelectRow:String = ""
    var indexForEdit:Int = 0
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
        dashboardTableView.backgroundColor = .clear
        dashboardCollectionView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        dashboardCollectionView.layer.cornerRadius = 10
        dashboardTableView.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
//        getDataFromFire(queryBy: "Staff Name")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.dashboardLeading.constant = 20
            self.dashboardCollectionLeading.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dashboardLeading.constant = -400
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
        NotificationCenter.default.post(name: .dataIndex, object: self)
        animateTable()
        dashboardCollectionView.reloadData()
        
    }
    
}

extension DashboardViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch dataIndex {
        case SelectedCollectionItem.staff.rawValue:
            guard staff?.count > 0 else {return 1}
            return staff?.count ?? 1
        case SelectedCollectionItem.place.rawValue:
            guard workPlace?.count > 0 else {return 1}
            return workPlace?.count ?? 1
        case SelectedCollectionItem.position.rawValue:
            guard position?.count > 0 else {return 1}
            return position?.count ?? 1
        case SelectedCollectionItem.shift.rawValue:
            guard shiftTemplate?.count > 0 else {return 1}
            return shiftTemplate?.count ?? 1
        default:
            break
        }
        return 1
    }
    func setIconImage(icon:String)->UIImage{
        let image = UIImage(named: icon)
        return image!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 17)
        cell.backgroundColor = .clear
        switch dataIndex {
        case SelectedCollectionItem.staff.rawValue:
            cell.textLabel?.text = staff?.count == 0 ? "No staff data" : staff?[indexPath.row].employeeName
            cell.imageView?.image = setIconImage(icon: "human")
        case SelectedCollectionItem.place.rawValue:
            cell.textLabel?.text = workPlace?.count == 0 ? "No place data" : workPlace?[indexPath.row].placename
            cell.imageView?.image = setIconImage(icon: "location")
        case SelectedCollectionItem.position.rawValue:
            cell.textLabel?.text = position?.count == 0 ? "No position data" : position?[indexPath.row].positionName
            cell.imageView?.image = setIconImage(icon: "case")
        case SelectedCollectionItem.shift.rawValue:
            cell.imageView?.image = setIconImage(icon: "cal")
            if shiftTemplate?.count == 0 {
                cell.textLabel?.text = "No regular shift data"
            }
            if shiftTemplate?.count > 0 {
                guard let shift = shiftTemplate?[indexPath.row] else { return cell}
                cell.textLabel?.text = shift.shiftTemplateName
                cell.detailTextLabel?.text = "\(shift.shiftTimeStart) - \(shift.shiftTimeEnd)"
                cell.detailTextLabel?.textColor = .lightText
            }

        default:
            break
        }
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch dataIndex {
        case 0:
            guard staff?.count > 0 else { return }
            dashboardSelectRow = staff?[indexPath.row].employeeName ?? ""
        case 1:
            guard workPlace?.count > 0 else { return }
            dashboardSelectRow = workPlace?[indexPath.row].placename ?? ""
        case 2:
            guard position?.count > 0 else { return }
            dashboardSelectRow = position?[indexPath.row].positionName ?? ""
        case 3:
            guard shiftTemplate?.count > 0 else { return }
            dashboardSelectRow = shiftTemplate?[indexPath.row].shiftTemplateName ?? ""
        default:
            break
        }
        NotificationCenter.default.post(name: .dashboardSelectRow, object: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            tableView.deleteRows(at: [indexPath], with: .right)
            tableView.reloadRows(at: [indexPath], with: .middle)
            self.updateModel(at: indexPath, editPressed: false)
        }
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.updateModel(at: indexPath, editPressed: true)
            self.indexForEdit = indexPath.row
            NotificationCenter.default.post(name: .indexForEdit, object: self)
        }
        edit.backgroundColor = .lightGray
        
        return [delete,edit]
    }
    
    func updateModel(at indexPath:IndexPath, editPressed:Bool){
        switch dataIndex {
        case SelectedCollectionItem.staff.rawValue:
            guard let staffForDelete = staff?[indexPath.row] else { return }
            editPressed == true ?
                editModel(modelForEdit: staffForDelete, indexPath: indexPath) :
                deleteModel(modelForDelete: staffForDelete)
        case SelectedCollectionItem.place.rawValue:
            if workPlace?.count > 0 {
                guard let placeForDelete = workPlace?[indexPath.row] else { return }
                editPressed == true ?
                    editModel(modelForEdit: placeForDelete, indexPath: indexPath) :
                    deleteModel(modelForDelete: placeForDelete)
            }
        case SelectedCollectionItem.position.rawValue:
            
            guard let positionForDelete = position?[indexPath.row] else { return }
            editPressed == true ?
                editModel(modelForEdit: positionForDelete, indexPath: indexPath) :
                deleteModel(modelForDelete: positionForDelete)
        case SelectedCollectionItem.shift.rawValue:
            
            guard let shiftForDelete = shiftTemplate?[indexPath.row] else { return }
            editPressed == true ?
                performSegue(withIdentifier: "shiftForEdit", sender: self) :
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
        loadData()
        dashboardTableView.reloadData()
    }
    func editModel(modelForEdit:EditProtocol,indexPath:IndexPath){
        switch dataIndex {
        case SelectedCollectionItem.staff.rawValue:
            editAlert(UIImageName:"Employees",object:modelForEdit,indexPath:indexPath)
        case SelectedCollectionItem.place.rawValue:
            editAlert(UIImageName:"place",object:modelForEdit,indexPath:indexPath)
        case SelectedCollectionItem.position.rawValue:
            editAlert(UIImageName:"position",object:modelForEdit,indexPath:indexPath)
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch dataIndex {
        case SelectedCollectionItem.staff.rawValue:
            guard staff?.count > 0 else { return false}
            return true
        case SelectedCollectionItem.place.rawValue:
            guard workPlace?.count > 0 else { return false}
            return true
        case SelectedCollectionItem.position.rawValue:
            guard position?.count > 0 else { return false}
            return true
        case SelectedCollectionItem.shift.rawValue:
            guard shiftTemplate?.count > 0 else { return false}
            return true
        default:
            break
        }
        return true
    }
    func animateTable(){
        dashboardTableView.reloadData()
        let cells = dashboardTableView.visibleCells
        
        var tableviewWidth:CGFloat {
            if dataIndex >= oldIndex{
                return dashboardTableView.bounds.size.width
            }else{
                return -dashboardTableView.bounds.size.width
            }
        }
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
    func editAlert(UIImageName:String,object:EditProtocol,indexPath:IndexPath){
        let editTitle = UITextField()
        let alert = UIAlertController(style: .alert, title:"Edit")
        let image = UIImage(named: UIImageName)
        let config: TextField.Config = { textField in
            textField.clearButtonMode = .whileEditing
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.text = object.edit()
            textField.autocapitalizationType = .words
            textField.left(image: image,color: .gray)
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.returnKeyType = .done
            textField.action { textField in
                editTitle.text = textField.text!
            }
        }
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            guard editTitle.text != "" else { return }
            do{
                try self.realm.write {
                    let model = object
                    model.result(editTitle.text!)
//                    self.workPlace?[indexPath.row].placename = editTitle.text!
                }
            }catch{
                print("Error editing staff \(error)")
            }
            self.dashboardTableView.reloadData()
        }

        alert.addOneTextField(configuration: config)
        alert.addAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
        alert.show()
    }
    func addModelAlert(alertTitle:String,icon:String,placeHolder:String,model:AddDataToRealm){
        let name = UITextField()
        let alert = UIAlertController(style: .alert, title: alertTitle)
        let image = UIImage(named: icon)
        let config: TextField.Config = { textField in
            textField.clearButtonMode = UITextFieldViewMode.whileEditing
            ///why textfield didn't become first responder
            textField.textColor = .black
            textField.placeholder = placeHolder
            textField.autocapitalizationType = .words
            textField.left(image: image,color: .gray)
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.returnKeyType = .done
            textField.action { textField in
                name.text = textField.text
//                self.setDashboardModel["\(placeHolder)"] = name.text
            }
            
        }
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            guard name.text != "" else { return }
            let newModel = model
            newModel.add(name.text!)
            self.saveObject(to: newModel as! Object)
//            self.addDataToFire(model: "\(placeHolder)", setValue: self.setDashboardModel)
//            self.setDashboardModel = [:]
            
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(title: "Cancel", style: .cancel)
        alert.addAction(action)
//        alert.show()
        present(alert,animated: true, completion: nil)
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
