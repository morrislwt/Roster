//
//  TodoListViewController.swift
//  Roster
//
//  Created by Morris on 2018/5/21.
//  Copyright © 2018年 Morris. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController:UIViewController{
    @IBOutlet weak var backgroundOutlet: UIView!
    @IBAction func backToAgenda(_ segue:UIStoryboardSegue){
        
    }
    
    @IBOutlet weak var leadingBackground: NSLayoutConstraint!
    @IBOutlet weak var agendaTableView: UITableView!
    
    @IBAction func addBtnPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "addTodo", sender: self)
    }

    let realm = try! Realm()
    var todoArray:Results<TodoData>?
    
    
    func loadAgenda(){
        todoArray = realm.objects(TodoData.self)
        agendaTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        agendaTableView.tableFooterView = UIView()
        agendaTableView.layer.cornerRadius = 30
        agendaTableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        backgroundOutlet.layer.cornerRadius = 20
        backgroundOutlet.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadAgenda()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.leadingBackground.constant = -20
            self.view.layoutIfNeeded()
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.leadingBackground.constant = -400
    }
}


extension TodoListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard todoArray?.count > 0 else {return 1}
        return todoArray?.count ?? 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if todoArray?.count == 0 {
            cell.textLabel?.text = "Add some things ✏️"
            cell.backgroundColor = .clear
        }
        if todoArray?.count > 0 {
            guard let item = todoArray?[indexPath.row] else { return cell }
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
            cell.detailTextLabel?.textColor = .darkGray
            cell.tintColor = .gray
            cell.accessoryType = item.isChecked ? .checkmark : .none
            cell.backgroundColor = .clear
        }

        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if todoArray?.count == 0 {
            return false
        }else{
            return true
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard todoArray?.count > 0 else { return }
        guard let item = todoArray?[indexPath.row] else { return }
            do{
                try realm.write {
                    item.isChecked = !item.isChecked
                }
            }catch{
                print("Error saving checked status, \(error)")
            }
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height = view.frame.height
        return height * 80 / height
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
//            tableView.reloadRows(at: tableView.indexPathsForVisibleRows!, with: .automatic)
            self.updateModel(at: indexPath)
//            tableView.deleteRows(at: [indexPath], with: .right)
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) in
            self.editModel(at: indexPath)
        }
        edit.backgroundColor = UIColor.lightGray
        
        return [delete, edit]
        
    }
    func updateModel(at indexPath: IndexPath){
        if let agendaForDeletion = self.todoArray?[indexPath.row] {
            deleteModel(itemForDelete: agendaForDeletion)
        }
        //update our data model
    }
    func editModel(at indexPath: IndexPath){
        if let agendaForEdit = todoArray?[indexPath.row]{
            var editTitle = UITextField()
            var editSubtitle = UITextField()
            
            
            let alert = UIAlertController(title: "Edit", message: "", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.text = agendaForEdit.title
                editTitle = textField
            }
            alert.addTextField { (textField) in
                textField.text = agendaForEdit.subtitle
                editSubtitle = textField
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            let saveAction = UIAlertAction(title: "Save", style: .default) { (saveAction) in
                
                do{
                    try self.realm.write {
                        self.todoArray?[indexPath.row].title = editTitle.text!
                        self.todoArray?[indexPath.row].subtitle = editSubtitle.text!
                    }
                }catch{
                    print("Error editing Category \(error)")
                }
                self.agendaTableView.reloadData()
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
        loadAgenda()
//        agendaTableView.reloadData()
        animateTable()
    }
    func animateTable(){
        agendaTableView.reloadData()
        let cells = agendaTableView.visibleCells
        
        let tableViewHeight = agendaTableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: -tableViewHeight)
        }
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
    }
}
