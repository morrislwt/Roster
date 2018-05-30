////
////  PositionsVC.swift
////  SlideOutMenu
////
////  Created by Morris on 2018/4/20.
////  Copyright © 2018年 Morris. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class PositionsVC:UIViewController,UITableViewDataSource,UITableViewDelegate{
//    
//    @IBOutlet weak var positionTableView: UITableView!
//    
//    let realm = try! Realm()
//    var position:Results<PositionData>?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        loadData()
//        view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        positionTableView.tableFooterView = UIView()
//        
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        animateTable()
//    }
//    func loadData(){
//        position = realm.objects(PositionData.self)
//        positionTableView.reloadData()
//    }
//    
//    func saveData(dataFromWS: PositionData){
//        do{
//            try realm.write {
//                realm.add(dataFromWS)
//            }
//        }catch{
//            print("Error saving Positions \(error)")
//        }
//        positionTableView.reloadData()
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        
//        cell.textLabel?.text = position?[indexPath.row].positionName ?? "No positions add yet"
//        cell.textLabel?.font = UIFont(name: "Courier", size: 20)
//        
//        return cell
//    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return position?.count ?? 1
//    }
//    
//    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        
//        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            // delete item at indexPath
//            self.updateModel(at: indexPath)
//            tableView.deleteRows(at: [indexPath], with: .right)
//        }
//        
//        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
//            self.editModel(at: indexPath)
//        }
//        
//        edit.backgroundColor = UIColor.lightGray
//        
//        return [delete, edit]
//        
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80.0
//    }
//    
//    func updateModel(at indexPath: IndexPath){
//        if let positionForDeletion = self.position?[indexPath.row] {
//            deleteModel(itemForDelete: positionForDeletion)
//        }
//        //update our data model
//    }
//    func editModel(at indexPath: IndexPath){
//        if let positionForEdit = position?[indexPath.row].positionName{
//            var editText = UITextField()
//            
//            let alert = UIAlertController(title: "Edit", message: "Change the name of this Position", preferredStyle: .alert)
//            alert.addTextField { (textField) in
//                textField.text = positionForEdit
//                editText = textField
//            }
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            let saveAction = UIAlertAction(title: "Save", style: .default) { (saveAction) in
//                
//                do{
//                    try self.realm.write {
//                        self.position?[indexPath.row].positionName = editText.text!
//                    }
//                }catch{
//                    print("Error editing Category \(error)")
//                }
//                self.positionTableView.reloadData()
//            }
//            alert.addAction(saveAction)
//            present(alert,animated: true, completion: nil)
//        }
//    }
//    
//    func deleteModel(itemForDelete:Object){
//        do{
//            try realm.write {
//                realm.delete(itemForDelete)
//            }
//        }catch{
//            print("Error deleting item, \(error)")
//        }
//    }
//    @IBAction func addButtonPressed(_ sender: Any) {
//        var textField = UITextField()
//        
//        let alert = UIAlertController(title: "New Position", message: "Enter a new position", preferredStyle: .alert)
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addTextField { (addNewTextField) in
//            addNewTextField.placeholder = "a position name"
//            addNewTextField.autocorrectionType = .yes
//            addNewTextField.autocapitalizationType = .words
//            textField = addNewTextField
//        }
//        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
//            
//            let newPosition = PositionData()
//            newPosition.positionName = textField.text!
//            self.saveData(dataFromWS: newPosition)
//        }))
//        
//        present(alert,animated: true, completion: nil)
//        
//    }
//    public func animateTable(){
//        positionTableView.reloadData()
//        let cells = positionTableView.visibleCells
//        
//        
//        
//        let tableViewHeight = positionTableView.bounds.size.height
//        
//        for cell in cells {
//            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
//        }
//        var delayCounter = 0
//        for cell in cells {
//            UIView.animate(withDuration: 1.5, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
//                cell.transform = CGAffineTransform.identity
//            }, completion: nil)
//            delayCounter += 1
//        }
//    }
//
//}
//
