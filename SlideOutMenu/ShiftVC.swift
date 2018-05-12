//
//  File.swift
//  Roster
//
//  Created by Morris on 2018/5/6.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit


class ShiftVC:UIViewController,UITableViewDataSource,UITableViewDelegate,SwipeTableViewCellDelegate{

    @IBAction func backSegue(_ segue:UIStoryboardSegue){
        
    }

    @IBAction func addButtonPressed(_ sender: Any) {
//        var shiftTimeStart = UITextField()
//        var shiftTimeEnd = UITextField()
//        var shiftNameTextField = UITextField()
//        var shiftTotalTimeTextField = UITextField()
//
//        let alert = UIAlertController(title: "New Shift Template", message: "Enter a new name and time for this Shift ", preferredStyle: .alert)
//
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addTextField { (nameOfShift) in
//            nameOfShift.placeholder = "name of this shift. Ex: Open"
//            shiftNameTextField = nameOfShift
//        }
//        alert.addTextField { (startTime) in
//            startTime.placeholder = "start time"
//            startTime.keyboardType = .numberPad
//            shiftTimeStart = startTime
//        }
//        alert.addTextField { (endTime) in
//            endTime.placeholder = "end time"
//            endTime.keyboardType = .numberPad
//            shiftTimeEnd = endTime
//        }
//        let action = UIAlertAction(title: "Add", style: .default) { action in
//            let newShiftTemplate = shiftTemplateData()
//            newShiftTemplate.shiftTimeStart = shiftTimeStart.text!
//            newShiftTemplate.shiftTimeEnd = shiftTimeEnd.text!
//            newShiftTemplate.shiftTemplateName = shiftNameTextField.text!
//            self.saveData(dataFromWS: newShiftTemplate)
//        }
//        alert.addAction(action)
//
//        present(alert,animated: true, completion: nil)
    }
    
    @IBOutlet weak var shiftTemplateTableView: UITableView!
    var shiftTemplate:Results<shiftTemplateData>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        loadData()
        shiftTemplateTableView.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    func loadData(){
        shiftTemplate = realm.objects(shiftTemplateData.self)
        shiftTemplateTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
        }


        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = .clear
        deleteAction.transitionDelegate = ScaleTransition.default
        deleteAction.textColor = .gray

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()

        options.expansionStyle = .destructive
        options.expansionDelegate = ScaleAndAlphaExpansion.default
        return options
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func updateModel(at indexPath: IndexPath){
        if let shiftForDeletion = self.shiftTemplate?[indexPath.row] {
            deleteModel(itemForDelete: shiftForDeletion)
        }
        //update our data model
    }
    func editModel(at indexPath: IndexPath){
        if let shiftForEdit = shiftTemplate?[indexPath.row]{
            var editStart = UITextField()
            var editEnd = UITextField()

            let alert = UIAlertController(title: "Edit", message: "Change the time of this shift", preferredStyle: .alert)
            alert.addTextField { (startTime) in
                startTime.text = shiftForEdit.shiftTimeStart
                startTime.keyboardType = .numberPad
                editStart = startTime
            }
            alert.addTextField { (endTime) in
                endTime.text = shiftForEdit.shiftTimeEnd
                endTime.keyboardType = .numberPad
                editEnd = endTime
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            let saveAction = UIAlertAction(title: "Save", style: .default) { (saveAction) in

                do{
                    try self.realm.write {
                        self.shiftTemplate?[indexPath.row].shiftTimeStart = editStart.text!
                        self.shiftTemplate?[indexPath.row].shiftTimeEnd = editStart.text!
                    }
                }catch{
                    print("Error editing Category \(error)")
                }

                self.shiftTemplateTableView.reloadData()
            }
            alert.addAction(saveAction)
            present(alert,animated: true, completion: nil)
        }
    }
    
    func deleteModel(itemForDelete:Object){
        do{
            try realm.write {
                realm.delete(itemForDelete)
            }
        }catch{
            print("Error deleting item, \(error)")
        }
    }
    

}
extension ShiftVC{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shiftTemplate?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SwipeTableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.delegate = self

        if let shiftData = shiftTemplate{
            cell.textLabel?.text = shiftData[indexPath.row].shiftTemplateName
            cell.detailTextLabel?.text = "\(shiftData[indexPath.row].shiftTimeStart) - \(shiftData[indexPath.row].shiftTimeEnd)"
            cell.textLabel?.font = UIFont(name: "Courier", size: 20)
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showShiftDetail", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editDetailVC = segue.identifier as? ShiftVC_second {
            
        }
    }
    func animateTable(){
        shiftTemplateTableView.reloadData()
        let cells = shiftTemplateTableView.visibleCells
        
        
        let tableViewHeight = shiftTemplateTableView.bounds.size.height
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
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
