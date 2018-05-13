//
//  EmployeesVC.swift
//  SlideOutMenu
//
//  Created by Morris on 2018/4/20.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
import RealmSwift


class EmployeesVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    @IBOutlet weak var employeeTableView: UITableView!
    
    var employee:Results<EmployeeData>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        employeeTableView.tableFooterView = UIView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateTable()
    }
    func loadData(){
        employee = realm.objects(EmployeeData.self)
        employeeTableView.reloadData()
    }
    
    func saveData(dataFromWS: EmployeeData){
        do{
            try realm.write {
                realm.add(dataFromWS)
            }
        }catch{
            print("Error saving Positions \(error)")
        }
        employeeTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = employee?[indexPath.row].employeeName ?? "No staff add yet"
        cell.textLabel?.font = UIFont(name: "Courier", size: 20)
        
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employee?.count ?? 1
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            self.updateModel(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .right)
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.editModel(at: indexPath)
        }
        
        edit.backgroundColor = UIColor.lightGray
        
        return [delete, edit]
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func updateModel(at indexPath: IndexPath){
        if let employeeForDeletion = self.employee?[indexPath.row] {
            deleteModel(itemForDelete: employeeForDeletion)
        }
        //update our data model
    }
    func editModel(at indexPath: IndexPath){
        if let employeeForEdit = employee?[indexPath.row].employeeName{
            var editText = UITextField()

            let alert = UIAlertController(title: "Edit", message: "Change the name of this Employee", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = employeeForEdit
                editText = textField
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            let saveAction = UIAlertAction(title: "Save", style: .default) { (saveAction) in

                do{
                    try self.realm.write {
                        self.employee?[indexPath.row].employeeName = editText.text!
                    }
                }catch{
                    print("Error editing Category \(error)")
                }
                self.employeeTableView.reloadData()
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
    @IBAction func addButtonPressed(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "New employee", message: "Enter a new employee", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { (addNewTextField) in
            addNewTextField.placeholder = "a employee name"
            textField = addNewTextField
        }
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newEmployee = EmployeeData()
            newEmployee.employeeName = textField.text!
            self.saveData(dataFromWS: newEmployee)
        }
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
    }
    func animateTable(){
        employeeTableView.reloadData()
        let cells = employeeTableView.visibleCells
        let tableViewHeight = employeeTableView.bounds.size.height
        
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
